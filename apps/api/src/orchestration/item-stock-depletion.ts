import { PrismaClient } from "@prisma/client";

export interface ItemDepletionSummary {
  menuItemId: string;
  previousStock: number;
  stockQty: number;
  isStocked: boolean;
  quantityDeducted: number;
}

/**
 * Deducts portion stock from item_availability when an order is punched/confirmed.
 * Prevents double deduction by recording an audit log per order_item.
 */
export async function deductItemPortionsForOrder(
  orderId: string,
  outletId: string,
  prisma: PrismaClient,
  actorUserId?: string
): Promise<ItemDepletionSummary[]> {
  const orderItems = await prisma.orderItem.findMany({
    where: { orderId, isVoided: false },
  });

  if (orderItems.length === 0) return [];

  const updatedSummaries: ItemDepletionSummary[] = [];

  // Channel accounts for the outlet
  const accounts = await prisma.channelAccount.findMany({
    where: { outletId },
    select: { id: true },
  }).catch(() => []);
  const channelIds = accounts.length > 0 ? accounts.map((a) => a.id) : [outletId];

  for (const item of orderItems) {
    if (!item.menuItemId) continue;

    // Idempotency: verify this specific orderItemId hasn't already had portions depleted
    const alreadyDepleted = await prisma.auditLog.findFirst({
      where: {
        outletId,
        entityType: "PORTION_DEPLETED",
        entityId: item.id,
      },
    }).catch(() => null);

    if (alreadyDepleted) {
      continue;
    }

    const qtyToDeduct = Math.max(1, Number(item.quantity) || 1);

    // Fetch current availability row for this item
    const existingRows = await prisma.$queryRaw<Array<{
      id: string;
      state: string;
      stock_qty: number | null;
      version: number;
    }>>`
      SELECT id, state::text, stock_qty, version
      FROM item_availability
      WHERE outlet_id = ${outletId}::uuid AND item_id = ${item.menuItemId}::uuid
    `.catch(() => []);

    let previousStock = 100;
    let newStock = 100;
    let nextState = "ON";

    if (existingRows.length > 0) {
      const primary = existingRows[0];
      previousStock = primary.stock_qty != null ? Number(primary.stock_qty) : 100;
      newStock = Math.max(0, previousStock - qtyToDeduct);
      nextState = newStock <= 0 ? "OFF" : (primary.state === "OFF" ? "OFF" : "ON");

      await prisma.$executeRaw`
        UPDATE item_availability
        SET stock_qty = ${newStock},
            state = ${nextState}::availability_state,
            version = version + 1,
            updated_at = NOW(),
            updated_by = ${actorUserId || null}::uuid
        WHERE outlet_id = ${outletId}::uuid AND item_id = ${item.menuItemId}::uuid
      `.catch((err) => {
        console.error(`Failed to update item_availability for ${item.menuItemId}:`, err);
      });
    } else {
      previousStock = 100;
      newStock = Math.max(0, 100 - qtyToDeduct);
      nextState = newStock <= 0 ? "OFF" : "ON";

      for (const chId of channelIds) {
        await prisma.$executeRaw`
          INSERT INTO item_availability (outlet_id, item_id, channel_id, state, stock_qty, version, created_at, updated_at, created_by, updated_by)
          VALUES (
            ${outletId}::uuid,
            ${item.menuItemId}::uuid,
            ${chId}::uuid,
            ${nextState}::availability_state,
            ${newStock},
            1,
            NOW(),
            NOW(),
            ${actorUserId || null}::uuid,
            ${actorUserId || null}::uuid
          )
        `.catch((err) => {
          console.error(`Failed to insert item_availability for ${item.menuItemId}:`, err);
        });
      }
    }

    // Record audit log for idempotency and audit tracking
    await prisma.auditLog.create({
      data: {
        outletId,
        userId: actorUserId || outletId,
        action: "UPDATE",
        entityType: "PORTION_DEPLETED",
        entityId: item.id,
        beforeState: { menuItemId: item.menuItemId, stockQty: previousStock },
        afterState: {
          menuItemId: item.menuItemId,
          stockQty: newStock,
          quantityDeducted: qtyToDeduct,
          isStocked: nextState !== "OFF",
        },
        reasonCode: "ORDER_PLACED",
        createdAt: new Date(),
      },
    }).catch(() => {});

    updatedSummaries.push({
      menuItemId: item.menuItemId,
      previousStock,
      stockQty: newStock,
      isStocked: nextState !== "OFF",
      quantityDeducted: qtyToDeduct,
    });
  }

  // Broadcast live updates if any items were modified
  if (updatedSummaries.length > 0) {
    import("../websockets").then(({ broadcast }) => {
      broadcast(outletId, "inventory.stock_updated", {
        orderId,
        items: updatedSummaries,
      });
      for (const up of updatedSummaries) {
        broadcast(outletId, "menu.item_availability_changed", {
          itemId: up.menuItemId,
          stockQty: up.stockQty,
          isStocked: up.isStocked,
        });
      }
    }).catch(() => {});
  }

  return updatedSummaries;
}

/**
 * Restores portion stock when an order item is voided or cancelled.
 */
export async function restoreItemPortionOnVoid(
  outletId: string,
  menuItemId: string,
  quantity: number,
  prisma: PrismaClient,
  actorUserId?: string,
  orderItemId?: string
): Promise<{ stockQty: number; isStocked: boolean } | null> {
  if (!menuItemId || quantity <= 0) return null;

  if (orderItemId) {
    const alreadyRestored = await prisma.auditLog.findFirst({
      where: {
        outletId,
        entityType: "PORTION_RESTORED",
        entityId: orderItemId,
      },
    }).catch(() => null);

    if (alreadyRestored) return null;
  }

  const existingRows = await prisma.$queryRaw<Array<{
    id: string;
    state: string;
    stock_qty: number | null;
  }>>`
    SELECT id, state::text, stock_qty
    FROM item_availability
    WHERE outlet_id = ${outletId}::uuid AND item_id = ${menuItemId}::uuid
  `.catch(() => []);

  if (existingRows.length === 0) return null;

  const currentStock = existingRows[0].stock_qty != null ? Number(existingRows[0].stock_qty) : 0;
  const newStock = currentStock + quantity;
  const nextState = newStock > 0 ? "ON" : existingRows[0].state;

  await prisma.$executeRaw`
    UPDATE item_availability
    SET stock_qty = ${newStock},
        state = ${nextState}::availability_state,
        version = version + 1,
        updated_at = NOW(),
        updated_by = ${actorUserId || null}::uuid
    WHERE outlet_id = ${outletId}::uuid AND item_id = ${menuItemId}::uuid
  `.catch((err) => {
    console.error(`Failed to restore item_availability for ${menuItemId}:`, err);
  });

  if (newStock > 0) {
    await prisma.menuItem.update({
      where: { id: menuItemId },
      data: { isActive: true },
    }).catch(() => {});
  }

  if (orderItemId) {
    await prisma.auditLog.create({
      data: {
        outletId,
        userId: actorUserId || outletId,
        action: "UPDATE",
        entityType: "PORTION_RESTORED",
        entityId: orderItemId,
        beforeState: { menuItemId, stockQty: currentStock },
        afterState: {
          menuItemId,
          stockQty: newStock,
          quantityRestored: quantity,
          isStocked: nextState !== "OFF",
        },
        reasonCode: "ITEM_VOIDED",
        createdAt: new Date(),
      },
    }).catch(() => {});
  }

  import("../websockets").then(({ broadcast }) => {
    broadcast(outletId, "inventory.stock_updated", {
      items: [{ menuItemId, stockQty: newStock, isStocked: nextState !== "OFF" }],
    });
    broadcast(outletId, "menu.item_availability_changed", {
      itemId: menuItemId,
      stockQty: newStock,
      isStocked: nextState !== "OFF",
    });
  }).catch(() => {});

  return { stockQty: newStock, isStocked: nextState !== "OFF" };
}
