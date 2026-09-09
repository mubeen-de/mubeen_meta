import type { PrismaClient } from "@prisma/client";
import { createKot, PrismaKotRepository } from "@kapmeta/kitchen";
import { stampOrderMergeLabel } from "./table-merge";
import { deductItemPortionsForOrder } from "./item-stock-depletion";

export async function onOrderConfirmed(orderId: string, prisma: PrismaClient): Promise<void> {
  const order = await prisma.order.findUnique({
    where: { id: orderId },
    include: { orderItems: true },
  });
  if (!order) {
    console.error(`onOrderConfirmed: order ${orderId} not found`);
    return;
  }

  const alreadyTicketed = await prisma.$queryRaw<Array<{ order_item_id: string }>>`
    SELECT ki.order_item_id
    FROM kot_items ki
    JOIN kot_tickets kt ON ki.kot_ticket_id = kt.id
    WHERE kt.order_id = ${orderId}::uuid AND ki.order_item_id IS NOT NULL
  `.catch(() => []);
  const ticketedIds = new Set(
    (alreadyTicketed || []).map((row) => row.order_item_id).filter(Boolean)
  );

  const newLines = order.orderItems.filter((item) => !item.isVoided && !ticketedIds.has(item.id));
  if (newLines.length === 0) {
    return;
  }

  try {
    await createKot(
      {
        outletId: order.outletId,
        orderId: order.id,
        lines: newLines.map((item) => ({
          menuItemId: item.menuItemId,
          quantity: Number(item.quantity) || 1,
          notes: item.notes ?? undefined,
          course: item.course ?? undefined,
          orderItemId: item.id,
        })),
      },
      new PrismaKotRepository(prisma),
    );

    // Deduct available portions from item_availability
    await deductItemPortionsForOrder(order.id, order.outletId, prisma).catch((err) => {
      console.error(`onOrderConfirmed: deductItemPortionsForOrder failed for order ${orderId}`, err);
    });

    if (order.diningTableId) {
      await stampOrderMergeLabel(prisma, order.outletId, order.id, order.diningTableId);
    }
    const table = order.diningTableId
      ? await prisma.diningTable.findFirst({
          where: { id: order.diningTableId },
          select: { tableNumber: true, mergeGroupId: true, mergePrimaryTableId: true },
        })
      : null;
    import("../websockets").then(({ broadcast }) => {
      broadcast(order.outletId, "kot.created", {
        orderId: order.id,
        diningTableId: order.diningTableId,
        tableNumber: table?.tableNumber || null,
      });
      if (order.diningTableId) {
        broadcast(order.outletId, "order.updated", { orderId: order.id, diningTableId: order.diningTableId });
        broadcast(order.outletId, "table.status_updated", { tableId: order.diningTableId, orderId: order.id, status: "OCCUPIED" });
      }
    }).catch(() => {});
  } catch (err) {
    console.error(`onOrderConfirmed: KOT creation failed for order ${orderId}`, err);
  }
}

export async function onItemsAdded(orderId: string, prisma: PrismaClient): Promise<void> {
  return onOrderConfirmed(orderId, prisma);
}
