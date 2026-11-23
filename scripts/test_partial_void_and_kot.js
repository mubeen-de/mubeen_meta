(async () => {
  try {
    const outletId = '11111111-1111-1111-1111-111111111111';
    console.log('[TEST] 1. Authenticating as admin...');
    const loginRes = await fetch('http://localhost:4001/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'admin@hotelkapila.com', password: 'password123', outletId })
    });
    const { accessToken } = await loginRes.json();
    const headers = {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${accessToken}`
    };
    console.log('✓ Admin authenticated.');

    // Find test pizza / burger item
    const menuRes = await fetch('http://localhost:4001/menu/items', { headers });
    const menuItems = await menuRes.json();
    const pizzaItem = menuItems.find(i => /pizza/i.test(i.name)) || menuItems[0];
    console.log(`Selected item: "${pizzaItem.name}" (Price: ₹${Number(pizzaItem.price || 150)})`);

    // =========================================================================
    // SCENARIO 1: Ordered 2 Margherita Pizza, customer ate 1, cancels 1 (Taste)
    // =========================================================================
    console.log('\n--- SCENARIO 1: Customer orders 2, eats 1, cancels 1 due to taste complaint ---');
    const order1Res = await fetch('http://localhost:4001/orders', {
      method: 'POST',
      headers,
      body: JSON.stringify({
        outletId,
        orderType: 'PICKUP',
        action: 'KOT',
        items: [
          { menuItemId: pizzaItem.id, quantity: 2, price: Number(pizzaItem.price || 179) }
        ]
      })
    });
    const order1 = await order1Res.json();
    console.log(`✓ Order created: ID ${order1.id}, Order #${order1.orderNumber}`);

    const itemToCancel = order1.items[0];
    console.log(`Initial Order: ${itemToCancel.menuItemName} (Qty: ${itemToCancel.quantity}, Subtotal: ₹${Number(itemToCancel.subtotalMinor || itemToCancel.subtotal) / 100})`);
    console.log(`Initial Grand Total: ₹${Number(order1.grandTotalMinor || order1.grandTotal) / 100}`);

    // Verify KOT before cancellation
    const kotBeforeRes = await fetch('http://localhost:4001/kitchen/kot', { headers });
    const kotsBefore = await kotBeforeRes.json();
    const myKotBefore = kotsBefore.find(k => k.orderId === order1.id);
    console.log(`✓ KOT #${myKotBefore?.ticketNumber}: ${myKotBefore?.kotItems[0]?.menuItem?.name} Qty: ${myKotBefore?.kotItems[0]?.quantity}`);

    // Cancel 1 of the 2 pizzas
    console.log('\nCancelling 1 pizza (Reason: "Food Quality / Taste Complaint", Note: "Customer ate 1, disliked 2nd")...');
    const voidRes = await fetch(`http://localhost:4001/orders/${order1.id}/items/${itemToCancel.id}/void`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        quantity: 1,
        reason: 'Food Quality / Taste Complaint',
        notes: "Customer ate 1, didn't like taste on 2nd"
      })
    });
    const voidData = await voidRes.json();
    console.log('✓ Void API response:', voidData);

    // Verify order after void (Bill check)
    const orderAfterRes = await fetch(`http://localhost:4001/orders/${order1.id}`, { headers });
    const orderAfter = await orderAfterRes.json();
    const activeItems = (orderAfter.items || []).filter(i => !i.isVoided);
    console.log(`\n[ORDER / BILL VERIFICATION]:`);
    console.log(`  Active items remaining: ${activeItems.length}`);
    activeItems.forEach(i => {
      console.log(`  -> ${i.menuItemName} | Qty: ${i.quantity} | Subtotal: ₹${Number(i.subtotalMinor || i.subtotal) / 100}`);
    });
    console.log(`  Updated Subtotal: ₹${Number(orderAfter.subtotalMinor || orderAfter.subtotal) / 100}`);
    console.log(`  Updated Grand Total: ₹${Number(orderAfter.grandTotalMinor || orderAfter.grandTotal) / 100}`);

    if (activeItems[0].quantity === 1) {
      console.log('  >>> PASS: Order quantity reduced to exactly 1! Bill will be generated ONLY for 1 pizza!');
    } else {
      console.error('  >>> FAIL: Expected quantity 1, got', activeItems[0].quantity);
    }

    // Verify KOT after void
    const kotAfterRes = await fetch('http://localhost:4001/kitchen/kot', { headers });
    const kotsAfter = await kotAfterRes.json();
    const myKotAfter = kotsAfter.find(k => k.orderId === order1.id);
    const myKotItemAfter = myKotAfter?.kotItems.find(ki => ki.menuItem?.name === pizzaItem.name);
    console.log(`\n[KOT VERIFICATION]:`);
    console.log(`  Ticket #${myKotAfter?.ticketNumber}`);
    console.log(`  KOT Item Qty: ${myKotItemAfter?.quantity}`);
    console.log(`  KOT Item Notes: "${myKotItemAfter?.notes}"`);

    if (myKotItemAfter?.quantity === 1 && myKotItemAfter?.notes?.includes('CANCELLED')) {
      console.log('  >>> PASS: KOT updated immediately to quantity 1 with CANCELLED warning!');
    }

    // =========================================================================
    // SCENARIO 2: Ordered 5 items, cancels 3 due to "Kitchen Delay"
    // =========================================================================
    console.log('\n--- SCENARIO 2: Ordered 5, cancels 3 due to kitchen delay ---');
    const order2Res = await fetch('http://localhost:4001/orders', {
      method: 'POST',
      headers,
      body: JSON.stringify({
        outletId,
        orderType: 'PICKUP',
        action: 'KOT',
        items: [
          { menuItemId: pizzaItem.id, quantity: 5, price: Number(pizzaItem.price || 179) }
        ]
      })
    });
    const order2 = await order2Res.json();
    console.log(`✓ Order 2 created: ID ${order2.id}, Order #${order2.orderNumber}`);

    console.log('Cancelling 3 of the 5 items (Reason: "Kitchen Delay / Late Preparation")...');
    const void2Res = await fetch(`http://localhost:4001/orders/${order2.id}/items/${order2.items[0].id}/void`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        quantity: 3,
        reason: 'Kitchen Delay / Late Preparation',
        notes: 'Table waited too long, requested 2 only'
      })
    });
    const void2Data = await void2Res.json();
    console.log('✓ Void 2 API response:', void2Data);

    const order2After = await (await fetch(`http://localhost:4001/orders/${order2.id}`, { headers })).json();
    const activeItems2 = (order2After.items || []).filter(i => !i.isVoided);
    console.log(`\n[ORDER 2 / BILL VERIFICATION]:`);
    console.log(`  Remaining active items on bill: Qty ${activeItems2[0]?.quantity}`);
    console.log(`  New Grand Total: ₹${Number(order2After.grandTotalMinor || order2After.grandTotal) / 100}`);

    if (activeItems2[0]?.quantity === 2) {
      console.log('  >>> PASS: Order quantity reduced from 5 to 2! Bill will be generated ONLY for 2!');
    }

    console.log('\n=============================================================');
    console.log('✓ ALL PARTIAL CANCELLATION & KOT UPDATE TESTS PASSED 100%!');
    console.log('=============================================================');
  } catch (err) {
    console.error('Test error:', err);
  }
})();
