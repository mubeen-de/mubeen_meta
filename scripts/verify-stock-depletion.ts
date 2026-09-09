import "dotenv/config";
import { PrismaClient } from "@prisma/client";

const API_BASE = process.env.API_BASE || "http://localhost:4001";
const prisma = new PrismaClient();

async function run() {
  console.log("==================================================");
  console.log("   AUTOMATED STOCK DEPLETION & RESTORATION TEST   ");
  console.log("==================================================\n");

  // 1. Authenticate
  const loginRes = await fetch(`${API_BASE}/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      email: "admin@hotelkapila.com",
      password: "password123",
      outletId: "11111111-1111-1111-1111-111111111111",
    }),
  });

  if (!loginRes.ok) throw new Error(`Login failed: ${await loginRes.text()}`);
  const { accessToken } = (await loginRes.json()) as any;
  const headers = {
    Authorization: `Bearer ${accessToken}`,
    "Content-Type": "application/json",
  };
  console.log("✓ Logged in successfully");

  // 2. Fetch menu items to find "(2) Idly (1) Vada"
  const availRes = await fetch(`${API_BASE}/menu/availability`, { headers });
  if (!availRes.ok) throw new Error(`Fetch availability failed: ${await availRes.text()}`);
  const items: any[] = await availRes.json();
  const targetItem = items.find((i) => i.name.includes("Idly") && i.name.includes("Vada")) || items[0];
  console.log(`✓ Target item: "${targetItem.name}" (ID: ${targetItem.id})`);

  // 3. Set stock to 15 (which is < 20, triggering the waiter low stock badge)
  console.log("\nSetting initial stock to 15 portions...");
  const patchRes = await fetch(`${API_BASE}/menu/items/${targetItem.id}/availability`, {
    method: "PATCH",
    headers,
    body: JSON.stringify({ isStocked: true, stockQty: 15, expectedVersion: targetItem.version || 1 }),
  });
  if (!patchRes.ok) throw new Error(`Patch availability failed: ${await patchRes.text()}`);
  const patchData = await patchRes.json();
  console.log(`✓ Patched: stockQty = ${patchData.stockQty}, isStocked = ${patchData.isStocked}`);

  // Verify GET /menu/availability reflects 15
  const checkAvailRes = await fetch(`${API_BASE}/menu/availability`, { headers });
  const checkItems: any[] = await checkAvailRes.json();
  const checkedTarget = checkItems.find((i) => i.id === targetItem.id);
  console.log(`✓ GET /menu/availability returns stockQty: ${checkedTarget.stockQty}`);
  if (checkedTarget.stockQty !== 15) {
    throw new Error(`Expected stockQty 15 but got ${checkedTarget.stockQty}`);
  }

  // 4. Place an order for 3 portions
  console.log("\nPlacing order for 3 portions of target item...");
  const idempotencyKey = `test-stock-${Date.now()}`;
  const orderRes = await fetch(`${API_BASE}/orders`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      orderType: "DINE_IN",
      terminalNumber: "TEST-01",
      idempotencyKey,
      action: "KOT",
      status: "KOT_CREATED",
      lines: [
        {
          menuItemId: targetItem.id,
          quantity: 3,
        },
      ],
    }),
  });

  if (!orderRes.ok) throw new Error(`Create order failed: ${await orderRes.text()}`);
  const orderData = await orderRes.json();
  console.log(`✓ Order created: ID ${orderData.id}, OrderNumber ${orderData.orderNumber}`);

  // Allow async tasks/broadcast to settle
  await new Promise((r) => setTimeout(r, 600));

  // 5. Verify stock decreased: 15 - 3 = 12
  const postOrderRes = await fetch(`${API_BASE}/menu/availability`, { headers });
  const postOrderItems: any[] = await postOrderRes.json();
  const postOrderItem = postOrderItems.find((i) => i.id === targetItem.id);
  console.log(`✓ Post-order stockQty: ${postOrderItem.stockQty} (Expected: 12)`);
  if (postOrderItem.stockQty !== 12) {
    throw new Error(`Expected stockQty 12 but got ${postOrderItem.stockQty}`);
  }
  console.log("✓ Successfully verified: ordering reduced the item quantity!");

  // 6. Void the ordered line item to verify restoration
  console.log("\nTesting item void restoration...");
  const orderDetailRes = await fetch(`${API_BASE}/orders/${orderData.id}`, { headers });
  if (!orderDetailRes.ok) throw new Error("Failed to fetch order detail");
  const orderDetail = await orderDetailRes.json();
  const lineItem = orderDetail?.items?.[0];
  if (!lineItem) throw new Error("Order line item not found");

  const voidRes = await fetch(`${API_BASE}/orders/${orderData.id}/items/${lineItem.id}/void`, {
    method: "PATCH",
    headers,
    body: JSON.stringify({ reasonCode: "TEST_VOID" }),
  });
  if (!voidRes.ok) throw new Error(`Void item failed: ${await voidRes.text()}`);
  console.log("✓ Voided order item successfully");

  await new Promise((r) => setTimeout(r, 600));

  // Verify stock restored back: 12 + 3 = 15
  const postVoidRes = await fetch(`${API_BASE}/menu/availability`, { headers });
  const postVoidItems: any[] = await postVoidRes.json();
  const postVoidItem = postVoidItems.find((i) => i.id === targetItem.id);
  console.log(`✓ Post-void stockQty: ${postVoidItem.stockQty} (Expected: 15)`);
  if (postVoidItem.stockQty !== 15) {
    throw new Error(`Expected stockQty 15 after void but got ${postVoidItem.stockQty}`);
  }
  console.log("✓ Successfully verified: voiding restored the item quantity!");

  // 7. Test Depletion to 0 (Auto 86)
  console.log("\nTesting depletion to 0 (Auto 86)...");
  const orderRes2 = await fetch(`${API_BASE}/orders`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      orderType: "DINE_IN",
      terminalNumber: "TEST-01",
      idempotencyKey: `test-zero-${Date.now()}`,
      action: "KOT",
      status: "KOT_CREATED",
      lines: [
        {
          menuItemId: targetItem.id,
          quantity: 15,
        },
      ],
    }),
  });
  if (!orderRes2.ok) throw new Error(`Create order 2 failed: ${await orderRes2.text()}`);

  await new Promise((r) => setTimeout(r, 600));

  const postZeroRes = await fetch(`${API_BASE}/menu/availability`, { headers });
  const postZeroItems: any[] = await postZeroRes.json();
  const postZeroItem = postZeroItems.find((i) => i.id === targetItem.id);
  console.log(`✓ Post-zero stockQty: ${postZeroItem.stockQty}, isStocked: ${postZeroItem.isStocked}`);
  if (postZeroItem.stockQty !== 0 || postZeroItem.isStocked !== false) {
    throw new Error(`Expected stockQty 0 and isStocked false but got stockQty ${postZeroItem.stockQty}, isStocked ${postZeroItem.isStocked}`);
  }
  console.log("✓ Successfully verified: item reached 0 and automatically 86'd!");

  // Reset item back to stock 50 for normal operations
  console.log("\nResetting target item stock back to 50 for clean state...");
  await fetch(`${API_BASE}/menu/items/${targetItem.id}/availability`, {
    method: "PATCH",
    headers,
    body: JSON.stringify({ isStocked: true, stockQty: 50 }),
  });
  console.log("✓ Reset complete");

  console.log("\n==================================================");
  console.log("        ALL STOCK DEPLETION TESTS PASSED!         ");
  console.log("==================================================\n");
}

run()
  .then(() => prisma.$disconnect())
  .catch((err) => {
    console.error("Test failed:", err);
    prisma.$disconnect().then(() => process.exit(1));
  });
