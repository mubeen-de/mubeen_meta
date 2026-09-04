const { Client } = require('pg');

const DB_URLS = [
  process.env.DATABASE_URL || 'postgresql://pos:pos@localhost:5432/petpooja',
  'postgresql://pos:pos@localhost:5432/kapmeta'
];

async function syncDatabase(connStr) {
  const dbName = connStr.split('/').pop().split('?')[0];
  console.log(`\n======================================================`);
  console.log(`[FULL SYNC] Running complete dataset sync on: ${dbName}`);
  console.log(`======================================================`);

  const client = new Client({ connectionString: connStr });
  try {
    await client.connect();

    // Get primary outlet and admin user
    const outletRes = await client.query(`SELECT id, name FROM outlets ORDER BY created_at ASC LIMIT 1`);
    if (outletRes.rows.length === 0) {
      console.log(`  [WARN] No outlet found in ${dbName}, skipping entity sync.`);
      await client.end();
      return;
    }
    const outletId = outletRes.rows[0].id;
    console.log(`  Target Outlet: ${outletRes.rows[0].name} (${outletId})`);

    const userRes = await client.query(`SELECT id FROM users ORDER BY created_at ASC LIMIT 1`);
    const userId = userRes.rows.length > 0 ? userRes.rows[0].id : null;

    // 1. Sync Areas / Sections
    console.log(`  1. Syncing Areas / Dining Sections...`);
    const areas = [
      { name: 'AC', sort: 1 },
      { name: 'Non AC', sort: 2 },
      { name: 'Outdoor Garden', sort: 3 },
      { name: 'Terrace Lounge', sort: 4 },
      { name: 'Family Section', sort: 5 },
      { name: 'Other', sort: 6 }
    ];
    for (const a of areas) {
      await client.query(`
        INSERT INTO areas (outlet_id, name, sort_order, is_active, updated_at)
        VALUES ($1, $2, $3, true, NOW())
        ON CONFLICT (outlet_id, name) DO UPDATE SET sort_order = EXCLUDED.sort_order, is_active = true
      `, [outletId, a.name, a.sort]);
    }

    // 2. Sync Special Notes Presets
    console.log(`  2. Syncing Special Notes presets...`);
    const specialNotes = [
      { text: 'Less Masala', sort: 1 },
      { text: 'Extra Spicy', sort: 2 },
      { text: 'Jain Style (No Onion/Garlic)', sort: 3 },
      { text: 'Less Oil / Diet', sort: 4 },
      { text: 'Crispy / Well Done', sort: 5 },
      { text: 'No Sugar', sort: 6 },
      { text: 'Quick / VIP Priority', sort: 7 }
    ];
    for (const sn of specialNotes) {
      const exists = await client.query(`SELECT id FROM special_notes WHERE outlet_id = $1 AND text = $2`, [outletId, sn.text]);
      if (exists.rows.length === 0) {
        await client.query(`
          INSERT INTO special_notes (outlet_id, text, sort_order, is_active, updated_at)
          VALUES ($1, $2, $3, true, NOW())
        `, [outletId, sn.text, sn.sort]);
      }
    }

    // 3. Sync Taxes and Tax Channel Rules
    console.log(`  3. Syncing Taxes & Tax Channel Rules...`);
    const taxes = [
      { name: 'CGST', rate: 2.500 },
      { name: 'SGST', rate: 2.500 },
      { name: 'CGST [Online]', rate: 2.500 },
      { name: 'SGST [Online]', rate: 2.500 }
    ];
    const taxMap = {};
    for (const t of taxes) {
      const res = await client.query(`
        INSERT INTO taxes (outlet_id, name, rate_percent, is_active, updated_at)
        VALUES ($1, $2, $3, true, NOW())
        ON CONFLICT (outlet_id, name) DO UPDATE SET rate_percent = EXCLUDED.rate_percent, is_active = true
        RETURNING id, name
      `, [outletId, t.name, t.rate]);
      taxMap[res.rows[0].name] = res.rows[0].id;
    }

    // Scoping rules: backward for dine_in, forward for online
    const taxRules = [
      { tax: 'CGST', channel: 'dine_in', mode: 'backward' },
      { tax: 'SGST', channel: 'dine_in', mode: 'backward' },
      { tax: 'CGST [Online]', channel: 'online', mode: 'forward' },
      { tax: 'SGST [Online]', channel: 'online', mode: 'forward' }
    ];
    for (const tr of taxRules) {
      const taxId = taxMap[tr.tax];
      if (taxId) {
        const ruleExists = await client.query(`
          SELECT id FROM tax_channel_rules WHERE outlet_id = $1 AND tax_id = $2 AND channel = $3
        `, [outletId, taxId, tr.channel]);
        if (ruleExists.rows.length === 0) {
          await client.query(`
            INSERT INTO tax_channel_rules (outlet_id, tax_id, channel, mode, is_active, updated_at)
            VALUES ($1, $2, $3, $4, true, NOW())
          `, [outletId, taxId, tr.channel, tr.mode]);
        }
      }
    }

    // 4. Sync Payment Type Master
    console.log(`  4. Syncing Payment Type Master...`);
    const paymentTypes = [
      { label: 'Cash', isOnline: false, sort: 1 },
      { label: 'Card (EDC Terminal)', isOnline: false, sort: 2 },
      { label: 'UPI / QR Code', isOnline: false, sort: 3 },
      { label: 'Swiggy Settlement', isOnline: true, sort: 4 },
      { label: 'Zomato Settlement', isOnline: true, sort: 5 },
      { label: 'Room Service / Due', isOnline: false, sort: 6 },
      { label: 'Complimentary / House', isOnline: false, sort: 7 }
    ];
    for (const pt of paymentTypes) {
      await client.query(`
        INSERT INTO payment_type_master (outlet_id, label, is_online, is_active, sort_order, updated_at)
        VALUES ($1, $2, $3, true, $4, NOW())
        ON CONFLICT (outlet_id, label) DO UPDATE SET is_online = EXCLUDED.is_online, sort_order = EXCLUDED.sort_order, is_active = true
      `, [outletId, pt.label, pt.isOnline, pt.sort]);
    }

    // 5. Sync Outlet Settings & Status
    console.log(`  5. Syncing Outlet Billing & Print Settings...`);
    const billSettings = await client.query(`SELECT id FROM outlet_billing_settings WHERE outlet_id = $1`, [outletId]);
    if (billSettings.rows.length === 0) {
      await client.query(`
        INSERT INTO outlet_billing_settings (
          outlet_id, bill_prefix, kot_prefix, round_off_enabled, round_off_nearest, 
          service_charge_enabled, max_discount_percent, allow_discount_without_approval,
          require_customer_phone, require_otp_for_online, updated_at
        ) VALUES ($1, 'INV-', 'KOT-', true, 1.00, false, 50, false, false, false, NOW())
      `, [outletId]);
    }

    const printSettings = await client.query(`SELECT id FROM outlet_print_settings WHERE outlet_id = $1`, [outletId]);
    if (printSettings.rows.length === 0) {
      await client.query(`
        INSERT INTO outlet_print_settings (
          outlet_id, printer_name, paper_width_mm, print_logo, print_gstin, print_fssai_number,
          print_customer_details, auto_print_kot_on_place, auto_print_bill_on_settle,
          kot_copies, bill_copies, footer_message, updated_at
        ) VALUES (
          $1, 'Kitchen Thermal 80mm', 80, false, true, true, true, true, true, 1, 1,
          'Thank you for dining at Hotel Kapila! Please visit again.', NOW()
        )
      `, [outletId]);
    }

    await client.query(`
      INSERT INTO outlet_status (outlet_id, is_online, updated_at, updated_by)
      VALUES ($1, true, NOW(), $2)
      ON CONFLICT (outlet_id) DO UPDATE SET is_online = true, updated_at = NOW()
    `, [outletId, userId]);

    // 6. Sync Integrations, Aggregator Channel Accounts & Mapping
    console.log(`  6. Syncing Online Aggregators (Swiggy & Zomato)...`);
    const aggregators = [
      { code: 'SWIGGY', type: 'SWIGGY', extId: 'SW-KAPILA-01', cred: 'swiggy_production_v2' },
      { code: 'ZOMATO', type: 'ZOMATO', extId: 'ZM-KAPILA-01', cred: 'zomato_merchant_v1' }
    ];
    const channelAccountIds = [];
    for (const ag of aggregators) {
      const integRow = await client.query(`
        INSERT INTO integrations (code, type, is_active, updated_at)
        VALUES ($1, $2, true, NOW())
        ON CONFLICT (code) DO UPDATE SET is_active = true, updated_at = NOW()
        RETURNING id
      `, [ag.code, ag.type]);
      const integrationId = integRow.rows[0].id;

      let chRow = await client.query(`SELECT id FROM channel_accounts WHERE outlet_id = $1 AND external_outlet_id = $2`, [outletId, ag.extId]);
      if (chRow.rows.length === 0) {
        chRow = await client.query(`
          INSERT INTO channel_accounts (outlet_id, integration_id, external_outlet_id, credentials_ref, is_active, created_by, updated_at)
          VALUES ($1, $2, $3, $4, true, $5, NOW())
          RETURNING id
        `, [outletId, integrationId, ag.extId, ag.cred, userId]);
      }
      channelAccountIds.push(chRow.rows[0].id);
    }

    // Map top menu items to aggregator channels
    const menuItems = await client.query(`SELECT id, name FROM menu_items WHERE outlet_id = $1 LIMIT 10`, [outletId]);
    for (const caId of channelAccountIds) {
      for (const item of menuItems.rows) {
        const extItemId = 'EXT-' + item.name.substring(0, 4).toUpperCase() + '-' + item.id.substring(0, 4);
        const mapExists = await client.query(`
          SELECT id FROM channel_item_mapping WHERE outlet_id = $1 AND channel_account_id = $2 AND item_id = $3
        `, [outletId, caId, item.id]);
        if (mapExists.rows.length === 0) {
          await client.query(`
            INSERT INTO channel_item_mapping (outlet_id, channel_account_id, item_id, external_item_id, channel_code, version, updated_at)
            VALUES ($1, $2, $3, $4, 'MENU_V1', 1, NOW())
          `, [outletId, caId, item.id, extItemId]);
        }
      }
    }

    // 7. Sync Marketing Campaigns & Recipients
    console.log(`  7. Syncing Marketing Campaigns & Recipients...`);
    let campRes = await client.query(`SELECT id FROM marketing_campaigns WHERE outlet_id = $1 AND name = 'Weekend Biryani Fest'`, [outletId]);
    let campaignId;
    if (campRes.rows.length === 0) {
      const newCamp = await client.query(`
        INSERT INTO marketing_campaigns (outlet_id, name, trigger_type, message_template, status, created_by, updated_at)
        VALUES ($1, 'Weekend Biryani Fest', 'MANUAL', 'Enjoy 20% off on all signature biryanis this weekend at Hotel Kapila! Show code BIRYANI20 at billing.', 'ACTIVE', $2, NOW())
        RETURNING id
      `, [outletId, userId]);
      campaignId = newCamp.rows[0].id;
    } else {
      campaignId = campRes.rows[0].id;
    }

    const customers = await client.query(`SELECT id FROM customers WHERE outlet_id = $1`, [outletId]);
    for (const cust of customers.rows) {
      const recExists = await client.query(`SELECT id FROM campaign_recipients WHERE campaign_id = $1 AND customer_id = $2`, [campaignId, cust.id]);
      if (recExists.rows.length === 0) {
        await client.query(`
          INSERT INTO campaign_recipients (campaign_id, customer_id, status, created_at)
          VALUES ($1, $2, 'PENDING', NOW())
        `, [campaignId, cust.id]);
      }
    }

    // 8. Sync Notifications
    console.log(`  8. Syncing Operational Notifications...`);
    const notifications = [
      { type: 'INVENTORY_ALERT', title: 'Low Stock Alert', message: 'Basmati Rice is below reorder level (10 kg remaining).' },
      { type: 'ORDER_ALERT', title: 'Table A3 Billing Request', message: 'Table A3 has requested final physical invoice.' },
      { type: 'AGGREGATOR_ALERT', title: 'New Swiggy Order', message: 'Order #SW-8821 received and confirmed.' },
      { type: 'SYSTEM_ALERT', title: 'Shift Register Opened', message: 'Cashier shift opened on Terminal T-01.' }
    ];
    for (const n of notifications) {
      const notifExists = await client.query(`SELECT id FROM notifications WHERE outlet_id = $1 AND title = $2`, [outletId, n.title]);
      if (notifExists.rows.length === 0) {
        await client.query(`
          INSERT INTO notifications (outlet_id, user_id, type, title, message, is_read, updated_at)
          VALUES ($1, $2, $3, $4, $5, false, NOW())
        `, [outletId, userId, n.type, n.title, n.message]);
      }
    }

    // 9. Sync Sample Orders, Order Items & KOT Tickets
    console.log(`  9. Syncing Sample Orders & KOT Tickets...`);
    const today = new Date().toISOString().split('T')[0];
    const sampleMenuItems = await client.query(`SELECT id, name, price FROM menu_items WHERE outlet_id = $1 LIMIT 5`, [outletId]);
    const stationRes = await client.query(`SELECT id FROM stations WHERE outlet_id = $1 LIMIT 1`, [outletId]);
    const stationId = stationRes.rows.length > 0 ? stationRes.rows[0].id : null;

    if (sampleMenuItems.rows.length >= 2) {
      const item1 = sampleMenuItems.rows[0];
      const item2 = sampleMenuItems.rows[1];
      const p1 = Math.round(Number(item1.price || 50) * 100);
      const p2 = Math.round(Number(item2.price || 80) * 100);

      // Order 1: Live Occupied Table A1
      const ord1Exists = await client.query(`SELECT id FROM orders WHERE outlet_id = $1 AND order_number = 'ORD-101'`, [outletId]);
      let o1Id;
      if (ord1Exists.rows.length === 0) {
        const subtotal = p1 * 2 + p2;
        const o1 = await client.query(`
          INSERT INTO orders (
            outlet_id, order_number, type, status, business_date,
            subtotal_minor, total_minor, currency, table_number, tip_total_minor,
            service_charge_total_minor, round_off_minor, created_at, updated_at
          ) VALUES (
            $1, 'ORD-101', 'DINE_IN', 'IN_PREPARATION', $2,
            $3, $3, 'INR', 'A1', 0, 0, 0, NOW(), NOW()
          ) RETURNING id
        `, [outletId, today, subtotal]);
        o1Id = o1.rows[0].id;
      } else {
        o1Id = ord1Exists.rows[0].id;
      }

      const itemsCount = await client.query(`SELECT count(*) FROM order_items WHERE order_id = $1`, [o1Id]);
      if (parseInt(itemsCount.rows[0].count) === 0) {
        // Order Items
        const oi1 = await client.query(`
          INSERT INTO order_items (outlet_id, order_id, item_id, item_name, qty, unit_price_minor, total_price_minor)
          VALUES ($1, $2, $3, $4, 2, $5, $6) RETURNING id
        `, [outletId, o1Id, item1.id, item1.name, p1, p1 * 2]);

        const oi2 = await client.query(`
          INSERT INTO order_items (outlet_id, order_id, item_id, item_name, qty, unit_price_minor, total_price_minor)
          VALUES ($1, $2, $3, $4, 1, $5, $6) RETURNING id
        `, [outletId, o1Id, item2.id, item2.name, p2, p2]);

        // KOT Ticket
        if (stationId) {
          const kot1 = await client.query(`
            INSERT INTO kot_tickets (outlet_id, order_id, station_id, ticket_number, status, created_at, updated_at)
            VALUES ($1, $2, $3, 'KOT-101', 'QUEUED', NOW(), NOW())
            RETURNING id
          `, [outletId, o1Id, stationId]);

          await client.query(`
            INSERT INTO kot_items (kot_ticket_id, menu_item_id, quantity, order_item_id, outlet_id)
            VALUES ($1, $2, 2, $3, $4)
          `, [kot1.rows[0].id, item1.id, oi1.rows[0].id, outletId]);
        }
      }

      // Set table A1 as OCCUPIED
      await client.query(`UPDATE dining_tables SET status = 'OCCUPIED' WHERE outlet_id = $1 AND table_number = 'A1'`, [outletId]);

      // Order 2: Settled completed order from earlier today (for sales revenue)
      const ord2Exists = await client.query(`SELECT id FROM orders WHERE outlet_id = $1 AND order_number = 'ORD-100'`, [outletId]);
      if (ord2Exists.rows.length === 0) {
        const subtotal = p2 * 3;
        await client.query(`
          INSERT INTO orders (
            outlet_id, order_number, type, status, business_date,
            subtotal_minor, total_minor, currency, table_number, tip_total_minor,
            service_charge_total_minor, round_off_minor, settled_at, created_at, updated_at
          ) VALUES (
            $1, 'ORD-100', 'DINE_IN', 'COMPLETED', $2,
            $3, $3, 'INR', 'A2', 0, 0, 0, NOW(), NOW() - INTERVAL '2 hours', NOW()
          )
        `, [outletId, today, subtotal]);
      }

      // Order 3: Online Aggregator Swiggy order
      const ord3Exists = await client.query(`SELECT id FROM orders WHERE outlet_id = $1 AND order_number = 'ORD-SW-8821'`, [outletId]);
      if (ord3Exists.rows.length === 0) {
        const subtotal = p1 * 3;
        await client.query(`
          INSERT INTO orders (
            outlet_id, order_number, type, status, business_date,
            subtotal_minor, total_minor, currency, channel, external_order_id,
            rider_name, rider_phone, tip_total_minor, service_charge_total_minor, round_off_minor,
            created_at, updated_at
          ) VALUES (
            $1, 'ORD-SW-8821', 'DELIVERY', 'CONFIRMED', $2,
            $3, $3, 'INR', 'swiggy', 'SW-8821',
            'Suresh Kumar', '9848022338', 0, 0, 0,
            NOW(), NOW()
          )
        `, [outletId, today, subtotal]);
      }
    }

    console.log(`  \x1b[32m[SUCCESS] Complete dataset synchronized for ${dbName}!\x1b[0m`);
    await client.end();
  } catch (err) {
    console.error(`  [ERROR] Sync failed on ${dbName}:`, err);
    await client.end();
    throw err;
  }
}

async function main() {
  for (const url of DB_URLS) {
    await syncDatabase(url);
  }
  console.log(`\n\x1b[32m======================================================`);
  console.log(`[ALL DONE] Full dataset synchronization completed!`);
  console.log(`======================================================\x1b[0m\n`);
}

main().catch(err => {
  console.error("Master full dataset sync failed:", err);
  process.exit(1);
});
