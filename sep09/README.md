# Sep 09 Changes & Enhancements

## 1. Table & KOT Transfer Fix
- **Fixed Prisma Schema Runtime Error**:
  - Removed non-existent fields (`table_number`, `business_date`, `created_by`) passed into `Order.create` and `Order.update` in `apps/api/src/routes/tables.ts`.
- **Fixed Permission Denied (`table.transfer`)**:
  - Updated `/tables/transfer` to accept both `table.transfer` and `table.manage` permissions (`requirePermission("table.transfer", "table.manage")`).
  - Added `table.transfer` to `cashierActions` in `apps/api/src/db.ts` and granted to `CASHIER`, `WAITER`, `OUTLET_MANAGER`, and `SUPER_ADMIN` in the database.
- **Verified**:
  - Full end-to-end table transfer (`aw` -> `cv`) verified with 200 OK.

## 2. Parked / Held Orders Waiter Experience
- **Parked Draft Alert Banner in Cart (`PosBillingView.tsx`)**:
  - Real-time detection of parked drafts for the active table (`heldForCurrentTable`).
  - Banner displayed right above the cart table headers with:
    - Table Number, Item Count, Total Paise/Rupees, and Elapsed Park Time.
    - `[ ➕ Add to Cart ]`: Smartly merges held draft items into the active cart without wiping out freshly punched items.
    - `[ 🗑️ Discard Draft ]`: Clears the parked draft and clears badges across all screens.
  - Auto-cleans held orders for the table when the bill is settled upon payment.
- **Floor View Status Chip (`TableViewFloor.tsx`)**:
  - Added amber `⏸ Parked Draft` badge indicator to table cards on the floor map.
- **Header Drawer Synchronization (`KapMetaHeader.tsx`)**:
  - Wired `onResumeOrder` on `<HoldOrdersDrawer>` so clicking "Resume Order" navigates directly to `/?table=${ord.tableNumber}` and dispatches the merge event.

## 3. Advance Order Notification & Kitchen Prep Engine
- **Universal Floating Due Alert Banner (`AdvanceOrderAlertBanner.tsx`)**:
  - Detects advance orders that are due for kitchen prep (<= 30 minutes from fire time) or overdue.
  - Live countdown (`Due in X mins` / `Overdue by X mins`), Order Number, Order Type, and Customer Contact.
  - 1-Click `🔥 Fire to Kitchen`, `⏰ Snooze (5m)`, and quick registry link.
- **Harmonic 3-Tone Audio Chime (`posAudio.ts`)**:
  - Melodic attention chime ($D_5 \rightarrow A_5 \rightarrow D_6$) synthesized via Web Audio API.
- **Backend Due Detection & Shift Isolation (`apps/api/src/routes/orders.ts`)**:
  - Added `GET /orders/advance/due` endpoint.
  - Advance orders do not prematurely fire KOTs or deplete shift stock upon booking.
  - Firing an advance order automatically deducts the portion count from the active shift's stock batch.
- **WebSocket Broadcasts**:
  - Real-time events: `advance_order.created`, `advance_order.due`, and `advance_order.fired`.

## 4. Real-Time Stock & Menu Availability
- **Item Stock Depletion (`item-stock-depletion.ts`)**:
  - Automatically depletes menu item portion stock upon KOT dispatch.
  - Real-time low stock warnings (< 20 portions) displayed for waiters and cashier staff.
