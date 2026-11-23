const { Client } = require('pg');
const { execSync } = require('child_process');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const databaseUrl = process.env.DATABASE_URL || 'postgresql://pos:pos@localhost:5432/kapmeta';

async function verifyAndSeed() {
  const client = new Client({ connectionString: databaseUrl });
  try {
    await client.connect();
    const res = await client.query('SELECT count(*) FROM menu_items WHERE is_active = true');
    const count = parseInt(res.rows[0].count, 10) || 0;
    console.log(`[CATALOG CHECK] Found ${count} active menu items in database.`);

    if (count < 20) {
      console.log('\x1b[33m[AUTO-SEED] Menu catalog has few or no active items. Running full catalog seed...\x1b[0m');
      execSync('node scripts/replace_menu_catalog.js', { cwd: rootDir, stdio: 'inherit' });
      execSync('node scripts/seed_demo_recipes.js', { cwd: rootDir, stdio: 'inherit' });
      console.log('\x1b[32m[AUTO-SEED] ✓ Complete 219 items, categories, and recipes seeded successfully!\x1b[0m');
    } else {
      console.log(`\x1b[32m[CATALOG READY] Menu catalog is fully populated (${count} active dishes).\x1b[0m`);
    }

    // Ensure Swiggy and Zomato channel accounts exist for all outlets
    let swIntegRes = await client.query("SELECT id FROM integrations WHERE code = 'SWIGGY' OR type = 'SWIGGY'");
    let swIntegId = swIntegRes.rows[0]?.id;
    if (!swIntegId) {
      const ins = await client.query("INSERT INTO integrations (id, code, type, is_active, created_at, updated_at) VALUES (gen_random_uuid(), 'SWIGGY', 'SWIGGY', true, NOW(), NOW()) RETURNING id");
      swIntegId = ins.rows[0].id;
    }

    let zmIntegRes = await client.query("SELECT id FROM integrations WHERE code = 'ZOMATO' OR type = 'ZOMATO'");
    let zmIntegId = zmIntegRes.rows[0]?.id;
    if (!zmIntegId) {
      const ins = await client.query("INSERT INTO integrations (id, code, type, is_active, created_at, updated_at) VALUES (gen_random_uuid(), 'ZOMATO', 'ZOMATO', true, NOW(), NOW()) RETURNING id");
      zmIntegId = ins.rows[0].id;
    }

    const outletsRes = await client.query('SELECT id, name FROM outlets WHERE is_active = true');
    for (const outlet of outletsRes.rows) {
      const swiggyAcc = await client.query(
        "SELECT id FROM channel_accounts WHERE outlet_id = $1 AND (credentials_ref ILIKE '%swiggy%' OR external_outlet_id ILIKE '%sw%')",
        [outlet.id]
      );
      if (swiggyAcc.rows.length === 0) {
        const swOutletCode = `SW-${outlet.name.replace(/[^A-Za-z0-9]/g, '').slice(0, 8).toUpperCase()}-01`;
        await client.query(`
          INSERT INTO channel_accounts (id, outlet_id, integration_id, external_outlet_id, credentials_ref, is_active, created_at, updated_at)
          VALUES (gen_random_uuid(), $1, $2, $3, 'SWIGGY', true, NOW(), NOW())
        `, [outlet.id, swIntegId, swOutletCode]);
        console.log(`[INTEGRATION] ✓ Swiggy channel connected for outlet: ${outlet.name}`);
      }

      const zomatoAcc = await client.query(
        "SELECT id FROM channel_accounts WHERE outlet_id = $1 AND (credentials_ref ILIKE '%zomato%' OR external_outlet_id ILIKE '%zm%')",
        [outlet.id]
      );
      if (zomatoAcc.rows.length === 0) {
        const zmOutletCode = `ZM-${outlet.name.replace(/[^A-Za-z0-9]/g, '').slice(0, 8).toUpperCase()}-01`;
        await client.query(`
          INSERT INTO channel_accounts (id, outlet_id, integration_id, external_outlet_id, credentials_ref, is_active, created_at, updated_at)
          VALUES (gen_random_uuid(), $1, $2, $3, 'ZOMATO', true, NOW(), NOW())
        `, [outlet.id, zmIntegId, zmOutletCode]);
        console.log(`[INTEGRATION] ✓ Zomato channel connected for outlet: ${outlet.name}`);
      }
    }

    // Configure and verify the 4 Kitchen Departments / TV Stations
    try {
      const { setupDepartments } = require('./setup_4_kitchen_departments');
      await setupDepartments();
    } catch (deptErr) {
      console.warn(`[KITCHEN DEPT CHECK WARN] ${deptErr.message}`);
    }
  } catch (err) {
    console.warn(`[CATALOG CHECK WARN] ${err.message}`);
  } finally {
    await client.end().catch(() => {});
  }
}

verifyAndSeed().catch(console.error);
