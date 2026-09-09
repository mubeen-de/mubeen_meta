import "dotenv/config";

const API_BASE = process.env.API_BASE || "http://localhost:4001";

async function run() {
  console.log("==================================================");
  console.log("   AUTOMATED ADVANCE ORDER NOTIFICATION TEST      ");
  console.log("==================================================\n");

  // 1. Authenticate via /auth/login
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

  // 2. Fetch an active item
  const availRes = await fetch(`${API_BASE}/menu/availability`, { headers });
  if (!availRes.ok) throw new Error(`Fetch availability failed: ${await availRes.text()}`);
  const items: any[] = await availRes.json();
  const targetItem = items[0];
  console.log(`✓ Target item: "${targetItem.name}" (ID: ${targetItem.id})`);

  // 3. Reset portion stock for target item to 30
  const patchRes = await fetch(`${API_BASE}/menu/items/${targetItem.id}/availability`, {
    method: "PATCH",
    headers,
    body: JSON.stringify({ isStocked: true, stockQty: 30, expectedVersion: targetItem.version || 1 }),
  });
  if (!patchRes.ok) throw new Error(`Patch availability failed: ${await patchRes.text()}`);
  console.log("✓ Reset test item portion stock to 30 via API.");

  // 4. Create an Advance Order due in 15 minutes
  const now = new Date();
  const prepTime = new Date(now.getTime() + 15 * 60 * 1000); // 15 mins from now
  const promisedTime = new Date(now.getTime() + 45 * 60 * 1000); // 45 mins from now

  const pad = (n: number) => String(n).padStart(2, "0");
  const scheduledDate = `${prepTime.getFullYear()}-${pad(prepTime.getMonth() + 1)}-${pad(prepTime.getDate())}`;
  const scheduledTime = `${pad(prepTime.getHours())}:${pad(prepTime.getMinutes())}`;

  console.log(`\nBooking Advance Order for: ${scheduledDate} at ${scheduledTime} (Due in 15 mins)`);

  const idempotencyKey = `adv-test-${Date.now()}`;
  const orderPayload = {
    action: "DRAFT",
    orderType: "DELIVERY",
    customerName: "Sanjay Singhania",
    customerPhone: "9876543210",
    customerAddress: "Flat 402, Royal Palms, Mumbai",
    scheduledFireAt: prepTime.toISOString(),
    promisedAt: promisedTime.toISOString(),
    advancePaidRupees: 250,
    advanceStatus: "SCHEDULED",
    isAdvance: true,
    idempotencyKey,
    lines: [
      {
        menuItemId: targetItem.id,
        quantity: 5,
        unitPriceMinor: 10000,
      },
    ],
  };

  const createRes = await fetch(`${API_BASE}/orders`, {
    method: "POST",
    headers,
    body: JSON.stringify(orderPayload),
  });

  if (!createRes.ok) {
    throw new Error(`Failed to create advance order: ${await createRes.text()}`);
  }

  const createdOrder = (await createRes.json()) as any;
  console.log(`✓ Advance Order created! ID: ${createdOrder.id}, Number: ${createdOrder.orderNumber}`);

  // Fetch order details via API
  const orderDetailRes = await fetch(`${API_BASE}/orders/${createdOrder.id}`, { headers });
  const fetchedOrder = (await orderDetailRes.json()) as any;
  console.log(`Fetched Order status: "${fetchedOrder.status}" | customerId: "${fetchedOrder.customerId}"`);

  // Verify stock was NOT prematurely depleted before firing
  const checkAvail1 = await fetch(`${API_BASE}/menu/availability`, { headers });
  const checkItems1: any[] = await checkAvail1.json();
  const itemBeforeFire = checkItems1.find((i) => i.id === targetItem.id);
  console.log(`Stock before fire: ${itemBeforeFire.stockQty} (expected 30)`);
  if (itemBeforeFire.stockQty !== 30) {
    throw new Error(`❌ Stock was prematurely depleted! Current: ${itemBeforeFire.stockQty}`);
  }

  // 5. Test GET /orders/advance/due
  console.log("\nTesting GET /orders/advance/due?leadMinutes=30...");
  const dueRes = await fetch(`${API_BASE}/orders/advance/due?leadMinutes=30`, { headers });
  if (!dueRes.ok) throw new Error(`GET /orders/advance/due failed: ${await dueRes.text()}`);

  const dueList: any[] = await dueRes.json();
  console.log(`✓ Due advance orders returned: ${dueList.length}`);
  const found = dueList.find((o) => o.id === createdOrder.id);
  if (!found) {
    throw new Error("❌ Created order not found in due list!");
  }

  console.log(`✓ Order correctly detected in due queue!`);
  console.log(`  - raw found order:`, JSON.stringify(found, null, 2));
  console.log(`  - items: ${found.orderItems?.length}`);

  // 6. Test 1-Click Fire: POST /orders/:id/fire-advance
  console.log(`\nFiring advance order #${createdOrder.orderNumber} to kitchen via POST /orders/${createdOrder.id}/fire-advance...`);
  const fireRes = await fetch(`${API_BASE}/orders/${createdOrder.id}/fire-advance`, {
    method: "POST",
    headers,
  });

  if (!fireRes.ok) throw new Error(`Failed to fire advance order: ${await fireRes.text()}`);
  const fireData = await fireRes.json();
  console.log("✓ Advance order fired successfully!", fireData);

  // Allow async pipeline to complete
  await new Promise((r) => setTimeout(r, 600));

  // Check stock after fire: ordered 5 portions, 30 - 5 = 25!
  const checkAvail2 = await fetch(`${API_BASE}/menu/availability`, { headers });
  const checkItems2: any[] = await checkAvail2.json();
  const itemAfterFire = checkItems2.find((i) => i.id === targetItem.id);
  console.log(`Stock after fire: ${itemAfterFire.stockQty} (expected 25)`);
  if (itemAfterFire.stockQty !== 25) {
    throw new Error(`❌ Expected stock to be 25, got ${itemAfterFire.stockQty}`);
  }

  // 7. Verify order is NO LONGER in GET /orders/advance/due
  const dueAfterFire = await fetch(`${API_BASE}/orders/advance/due?leadMinutes=30`, { headers });
  const dueListAfter: any[] = await dueAfterFire.json();
  const stillFound = dueListAfter.find((o) => o.id === createdOrder.id);
  if (stillFound) {
    throw new Error("❌ Order still found in due list after being fired!");
  }
  console.log("✓ Fired order successfully cleared from due notifications queue!");

  // Reset stock back to 50 for clean operations
  await fetch(`${API_BASE}/menu/items/${targetItem.id}/availability`, {
    method: "PATCH",
    headers,
    body: JSON.stringify({ isStocked: true, stockQty: 50, expectedVersion: itemAfterFire.version || 1 }),
  });
  console.log("✓ Reset stock back to 50 for normal operations.");

  console.log("\n========================================================");
  console.log("🎉 ALL ADVANCE ORDER NOTIFICATION & FIRING TESTS PASSED!");
  console.log("========================================================");
}

run().catch((e) => {
  console.error("Unhandled verification error:", e);
  process.exit(1);
});
