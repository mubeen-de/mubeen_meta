import type { PrismaClient } from "@prisma/client";

let schedulerTimer: NodeJS.Timeout | null = null;

export function startAvailabilityScheduler(prisma: PrismaClient, intervalMs = 10000): void {
  if (schedulerTimer) return;
  schedulerTimer = setInterval(() => {
    checkAndResumeExpiredItems(prisma).catch((err) => {
      console.error("Availability auto-resume scheduler error:", err);
    });
  }, intervalMs);

  if (typeof schedulerTimer.unref === "function") {
    schedulerTimer.unref();
  }
}

export async function checkAndResumeExpiredItems(prisma: PrismaClient): Promise<number> {
  try {
    const expiredRows = await prisma.$queryRaw<Array<{
      id: string;
      outlet_id: string;
      item_id: string;
      version: number;
    }>>`
      SELECT id, outlet_id, item_id, version
      FROM item_availability
      WHERE state = 'OFF'::availability_state
        AND auto_resume_at IS NOT NULL
        AND auto_resume_at <= NOW()
    `.catch(() => []);

    if (!expiredRows || expiredRows.length === 0) return 0;

    const { broadcast } = await import("../websockets");

    for (const row of expiredRows) {
      const nextVersion = (row.version || 1) + 1;

      await prisma.$executeRaw`
        UPDATE item_availability
        SET state = 'ON'::availability_state,
            stock_qty = 100,
            auto_resume_at = NULL,
            version = ${nextVersion},
            updated_at = NOW()
        WHERE id = ${row.id}::uuid
      `.catch(() => {});

      await prisma.$executeRaw`
        UPDATE menu_item_availability
        SET is_out_of_stock = false,
            auto_resume_at = NULL,
            updated_at = NOW()
        WHERE menu_item_id = ${row.item_id}::uuid
      `.catch(() => {});

      await prisma.menuItem.update({
        where: { id: row.item_id },
        data: { isActive: true },
      }).catch(() => {});

      broadcast(row.outlet_id, "menu.item_availability_changed", {
        itemId: row.item_id,
        stockQty: 100,
        isStocked: true,
        autoResumeAt: null,
        version: nextVersion,
      });

      broadcast(row.outlet_id, "inventory.stock_updated", {
        items: [{ menuItemId: row.item_id, stockQty: 100, isStocked: true }],
      });
    }

    return expiredRows.length;
  } catch (err) {
    console.error("Error in checkAndResumeExpiredItems:", err);
    return 0;
  }
}
