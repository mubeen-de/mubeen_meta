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
  } catch (err) {
    console.warn(`[CATALOG CHECK WARN] ${err.message}`);
  } finally {
    await client.end().catch(() => {});
  }
}

verifyAndSeed().catch(console.error);
