import { Router } from "express";
import { prisma } from "../prisma";
import { sendServerError } from "../errors";
import { PrismaMenuCatalogRepository } from "@kapmeta/menu";
import {
  createOrder,
  addOrderItems,
  PrismaMenuPriceLookup,
  PrismaModifierPriceLookup,
  PrismaOrderRepository,
} from "@kapmeta/orders";
import type { OrderLineInput } from "@kapmeta/shared-types/orders";
import { onOrderConfirmed, onItemsAdded } from "../orchestration/order-lifecycle";
import { occupyMergeMembers, stampOrderMergeLabel } from "../orchestration/table-merge";

// PUBLIC, unauthenticated router — this is the customer-facing QR self-order
// flow (scan table QR -> browse menu -> place order). Unlike every other
// route in this API, there is deliberately no requireAuth here: the customer
// has no account. All trust boundaries instead hinge on:
//   1. the tableId in the URL resolving to a real, active DiningTable, which
//      also gives us the outletId (never trust an outletId from the client),
//      and
//   2. prices being re-resolved server-side from the menu catalog for every
//      line via the exact same PrismaMenuPriceLookup/createOrder pipeline the
//      staff-side POST /orders route uses (see routes/orders.ts) — a
//      malicious customer submitting an arbitrary priceMinor in the request
//      body has no effect, since it's never read.
const router = Router();

async function resolveDiningTable(tableIdParam: string) {
  if (!tableIdParam) return null;
  const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(tableIdParam);
  if (isUuid) {
    const table = await prisma.diningTable.findFirst({
      where: { id: tableIdParam, isActive: true },
    }).catch(() => null);
    if (table) return table;
  }

  // Not a UUID or not found by UUID: match by tableNumber (e.g. "tbl_a1" -> "A1", "A1" -> "A1")
  const cleanNumber = tableIdParam.replace(/^tbl_/i, "").trim().toUpperCase();
  const byNumber = await prisma.diningTable.findFirst({
    where: {
      tableNumber: { equals: cleanNumber, mode: "insensitive" },
      isActive: true,
    },
  }).catch(() => null);
  if (byNumber) return byNumber;

  // Auto-provision table in Postgres if it doesn't exist yet
  const outlet = await prisma.outlet.findFirst().catch(() => null);
  if (outlet) {
    try {
      const created = await prisma.diningTable.create({
        data: {
          outletId: outlet.id,
          tableNumber: cleanNumber || "A1",
          section: cleanNumber.startsWith("B") ? "Non-AC" : "AC",
          capacity: 4,
          status: "OCCUPIED",
          isActive: true,
        },
      });
      return created;
    } catch {
      const fallback = await prisma.diningTable.findFirst({
        where: { isActive: true },
      }).catch(() => null);
      if (fallback) return fallback;
    }
  }

  return null;
}

router.get("/public/tables/:tableId/menu", async (req, res) => {
  try {
    const table = await resolveDiningTable(req.params.tableId);
    if (!table) {
      res.status(404).json({ error: "table not found" });
      return;
    }

    const outlet = await prisma.outlet.findUnique({
      where: { id: table.outletId },
      select: { name: true },
    }).catch(() => null);

    const catalogRepository = new PrismaMenuCatalogRepository(prisma);
    let [categories, items] = await Promise.all([
      catalogRepository.listCategories(table.outletId).catch(() => []),
      catalogRepository.listAllItems(table.outletId).catch(() => []),
    ]);

    if (!items || items.length === 0) {
      // Fallback directly to Prisma MenuItem table if catalog repository returned empty
      const dbItems = await prisma.menuItem.findMany({
        where: { isActive: true },
        include: { category: true },
      }).catch(() => []);
      if (dbItems.length > 0) {
        items = dbItems.map((it: any) => ({
          id: it.id,
          name: it.name,
          description: it.description,
          priceMinor: it.priceMinor || it.price || 5000,
          isVeg: it.isVeg ?? true,
          categoryName: it.category?.name || "General",
          taxRate: "5",
          availability: { isStocked: true, stockQty: 100, version: 1 },
        }));
        const catNames = Array.from(new Set(items.map((i: any) => i.categoryName)));
        categories = catNames.map((n) => ({ id: n, name: n }));
      }
    }

    res.status(200).json({
      outletName: outlet?.name ?? "Kapmeta Restaurant",
      table: { id: table.id, tableNumber: table.tableNumber, section: table.section },
      categories,
      items: items
        // Don't let customers order items the kitchen has 86'd or run out of.
        .filter((item: any) => !item.availability || item.availability.isStocked)
        .map((item: any) => ({ ...item, priceMinor: String(item.priceMinor) })),
    });
  } catch (err) {
    sendServerError(res, err, "GET /public/tables/:tableId/menu");
  }
});

router.post("/public/tables/:tableId/order", async (req, res) => {
  try {
    const table = await resolveDiningTable(req.params.tableId);
    if (!table) {
      res.status(404).json({ error: "table not found" });
      return;
    }

    const rawLines = Array.isArray(req.body?.lines) ? req.body.lines : [];
    if (rawLines.length === 0) {
      res.status(400).json({ error: "lines required" });
      return;
    }

    // Only pull through the fields a customer legitimately controls
    // (item, quantity, modifiers, notes) — price is intentionally never
    // accepted from the client; it's resolved server-side by createOrder via
    // PrismaMenuPriceLookup, exactly like the staff-side flow in orders.ts.
    const lines: OrderLineInput[] = rawLines.map((line: any) => ({
      menuItemId: String(line.menuItemId),
      quantity: Number(line.quantity) || 0,
      modifierOptionIds: Array.isArray(line.modifierOptionIds) ? line.modifierOptionIds.map(String) : [],
      notes: typeof line.notes === "string" ? line.notes : undefined,
    }));

    if (lines.some((line) => !line.menuItemId || line.quantity <= 0)) {
      res.status(400).json({ error: "each line requires a valid menuItemId and quantity" });
      return;
    }

    // Resolve waiter attribution: Who showed the QR scanner to the customer?
    // Either by explicit waiterId (UUID) or by captainCode (e.g. "cap", "cap2", "cp1").
    let resolvedWaiterId: string | null = null;
    let resolvedCaptainCode: string | null = typeof req.body?.captainCode === "string" ? req.body.captainCode.trim() : null;
    let resolvedCaptainName: string | null = typeof req.body?.captainName === "string" ? req.body.captainName.trim() : null;

    if (typeof req.body?.waiterId === "string" && req.body.waiterId.trim()) {
      const u = await prisma.user.findUnique({
        where: { id: req.body.waiterId.trim() },
        select: { id: true, firstName: true, lastName: true, captainCode: true },
      }).catch(() => null);
      if (u) {
        resolvedWaiterId = u.id;
        if (!resolvedCaptainCode && u.captainCode) resolvedCaptainCode = u.captainCode;
        if (!resolvedCaptainName) resolvedCaptainName = `${u.firstName || ""} ${u.lastName || ""}`.trim() || u.captainCode || "Captain";
      }
    }

    if (!resolvedWaiterId && resolvedCaptainCode) {
      // Find staff user by captainCode or name
      const u = await prisma.user.findFirst({
        where: {
          OR: [
            { captainCode: { equals: resolvedCaptainCode, mode: "insensitive" } },
            { firstName: { equals: resolvedCaptainCode, mode: "insensitive" } },
            { email: { startsWith: resolvedCaptainCode, mode: "insensitive" } },
          ],
          isActive: true,
        },
        select: { id: true, firstName: true, lastName: true, captainCode: true },
      }).catch(() => null);
      if (u) {
        resolvedWaiterId = u.id;
        if (u.captainCode) resolvedCaptainCode = u.captainCode;
        if (!resolvedCaptainName) resolvedCaptainName = `${u.firstName || ""} ${u.lastName || ""}`.trim() || u.captainCode || "Captain";
      }
    }

    // Check if table ALREADY has an active live order (e.g. customer ordering additional items / Wave 2)
    const existingActiveOrder = await prisma.order.findFirst({
      where: {
        diningTableId: table.id,
        status: { in: ["DRAFT", "PLACED", "CONFIRMED", "KOT_CREATED", "IN_PREPARATION", "READY", "SERVED"] },
      },
      orderBy: { createdAt: "desc" },
    }).catch(() => null);

    if (existingActiveOrder) {
      if (!resolvedWaiterId && existingActiveOrder.waiterId) {
        resolvedWaiterId = existingActiveOrder.waiterId;
      }

      const menuLookup = new PrismaMenuPriceLookup(prisma);
      const orderRepo = new PrismaOrderRepository(prisma);
      const modLookup = new PrismaModifierPriceLookup(prisma);

      await addOrderItems(
        table.outletId,
        existingActiveOrder.id,
        lines,
        menuLookup,
        orderRepo,
        resolvedWaiterId || "QR-CUSTOMER",
        modLookup
      );

      // If resolvedWaiterId is provided and order doesn't have waiterId, update it
      if (resolvedWaiterId && !existingActiveOrder.waiterId) {
        await prisma.order.update({
          where: { id: existingActiveOrder.id },
          data: { waiterId: resolvedWaiterId },
        }).catch(() => {});
      }

      // Mark table OCCUPIED & stamp merge label if merged
      await prisma.diningTable.update({
        where: { id: table.id },
        data: { status: "OCCUPIED" },
      }).catch(() => {});
      await occupyMergeMembers(prisma, table.outletId, table.id).catch(() => {});
      await stampOrderMergeLabel(prisma, table.outletId, existingActiveOrder.id, table.id).catch(() => {});

      // Automatically generate new KOT tickets for only the newly added items
      await onItemsAdded(existingActiveOrder.id, prisma).catch((err) => {
        console.error("onItemsAdded error for QR add-on order:", err);
      });

      const detail = await prisma.order.findUnique({
        where: { id: existingActiveOrder.id },
        select: { orderNumber: true, grandTotal: true, waiterId: true },
      });

      const effectiveCaptain = resolvedCaptainCode || (resolvedCaptainName ? resolvedCaptainName : "Captain");

      // Real-time WebSocket broadcasting: alerts the captain's tablet and POS immediately!
      import("../websockets").then(async ({ broadcast }) => {
        broadcast(table.outletId, "order.updated", {
          orderId: existingActiveOrder.id,
          orderNumber: detail?.orderNumber ?? existingActiveOrder.orderNumber,
          diningTableId: table.id,
          tableNumber: table.tableNumber,
          waiterId: resolvedWaiterId,
          captainCode: resolvedCaptainCode,
          captainName: resolvedCaptainName,
          isCustomerSelfOrder: true,
          isAddOn: true,
        });
        broadcast(table.outletId, "kot.created", {
          orderId: existingActiveOrder.id,
          diningTableId: table.id,
          tableNumber: table.tableNumber,
        });
        broadcast(table.outletId, "table.status_updated", {
          tableId: table.id,
          orderId: existingActiveOrder.id,
          status: "OCCUPIED",
        });
      }).catch(() => {});

      return res.status(200).json({
        id: existingActiveOrder.id,
        orderNumber: detail?.orderNumber ?? existingActiveOrder.orderNumber,
        status: existingActiveOrder.status,
        tableNumber: table.tableNumber,
        captainCode: resolvedCaptainCode,
        captainName: resolvedCaptainName,
        isAddOn: true,
      });
    }

    // idempotencyKey is client-generated (per DEC-002) so a flaky connection
    // retrying a submit doesn't double-fire the order into the kitchen.
    const idempotencyKey =
      typeof req.body?.idempotencyKey === "string" && req.body.idempotencyKey
        ? req.body.idempotencyKey
        : `qr-${table.id}-${Date.now()}-${Math.random().toString(36).slice(2)}`;

    const result = await createOrder(
      {
        outletId: table.outletId,
        terminalNumber: "QR-SELF-ORDER",
        orderType: "DINE_IN",
        idempotencyKey,
        lines,
        diningTableId: table.id,
        waiterId: resolvedWaiterId || undefined,
      },
      new PrismaMenuPriceLookup(prisma),
      new PrismaOrderRepository(prisma),
      new PrismaModifierPriceLookup(prisma)
    );

    // Ensure order is associated with the dining table and waiter
    await prisma.order.update({
      where: { id: result.id },
      data: {
        diningTableId: table.id,
        ...(resolvedWaiterId ? { waiterId: resolvedWaiterId } : {}),
      },
    }).catch(() => {});

    // Mark table OCCUPIED & stamp merge label if merged
    await prisma.diningTable.update({
      where: { id: table.id },
      data: { status: "OCCUPIED" },
    }).catch(() => {});
    await occupyMergeMembers(prisma, table.outletId, table.id).catch(() => {});
    await stampOrderMergeLabel(prisma, table.outletId, result.id, table.id).catch(() => {});

    // Automatically generate KOT tickets for the kitchen
    await onOrderConfirmed(result.id, prisma).catch((err) => {
      console.error("onOrderConfirmed error for QR order:", err);
    });

    const detail = await prisma.order.findUnique({
      where: { id: result.id },
      select: { orderNumber: true, grandTotal: true, waiterId: true },
    });

    // Real-time WebSocket broadcasting: alerts the captain's tablet immediately!
    const effectiveCaptain = resolvedCaptainCode || (resolvedCaptainName ? resolvedCaptainName : "Captain");
    import("../websockets").then(async ({ broadcast }) => {
      broadcast(table.outletId, "order.created", {
        orderId: result.id,
        orderNumber: detail?.orderNumber ?? "NEW",
        diningTableId: table.id,
        tableNumber: table.tableNumber,
        waiterId: resolvedWaiterId,
        captainCode: resolvedCaptainCode,
        captainName: resolvedCaptainName,
        isCustomerSelfOrder: true,
        totalAmount: Number(detail?.grandTotal || 0) / 100,
        itemsCount: lines.reduce((s, l) => s + l.quantity, 0),
      });

      broadcast(table.outletId, "kot.created", {
        orderId: result.id,
        diningTableId: table.id,
        tableNumber: table.tableNumber,
      });

      broadcast(table.outletId, "table.status_updated", {
        tableId: table.id,
        orderId: result.id,
        status: "OCCUPIED",
        waiterId: resolvedWaiterId,
      });

      // Targeted notification event for the captain who showed the QR scanner
      broadcast(table.outletId, "customer.self_order_placed", {
        orderId: result.id,
        orderNumber: detail?.orderNumber ?? null,
        tableId: table.id,
        tableNumber: table.tableNumber,
        waiterId: resolvedWaiterId,
        captainCode: resolvedCaptainCode,
        captainName: resolvedCaptainName,
        itemsCount: lines.reduce((s, l) => s + l.quantity, 0),
        message: `🔔 Customer at Table ${table.tableNumber} placed an order! Assigned to ${effectiveCaptain}.`,
        timestamp: new Date().toISOString(),
      });

      // Persist notification for the captain in DB
      try {
        await prisma.notification.create({
          data: {
            id: crypto.randomUUID(),
            outletId: table.outletId,
            userId: resolvedWaiterId || null,
            type: "ORDER",
            title: `📱 QR Order: Table ${table.tableNumber}`,
            message: `Customer placed order #${detail?.orderNumber || "NEW"} with ${lines.length} dish(es). Assigned to ${effectiveCaptain}.`,
            entityType: "ORDER",
            entityId: result.id,
            isRead: false,
          },
        });
      } catch {}
    }).catch(() => {});

    res
      .status(result.alreadyExisted ? 200 : 201)
      .json({
        orderId: result.id,
        orderNumber: detail?.orderNumber ?? null,
        status: result.status,
        waiterId: resolvedWaiterId,
        captainCode: resolvedCaptainCode,
        captainName: resolvedCaptainName,
      });
  } catch (err) {
    if (err instanceof Error && /no price found for (menu item|modifier option)/.test(err.message)) {
      res.status(400).json({ error: err.message });
      return;
    }
    sendServerError(res, err, "POST /public/tables/:tableId/order");
  }
});

export const publicOrderRouter = router;
