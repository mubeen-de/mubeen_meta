const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

async function applySeedsToDb(dbName) {
  const client = new Client({ connectionString: `postgresql://pos:pos@localhost:5432/${dbName}` });
  await client.connect();
  console.log(`\nApplying core seeds and schema updates to [${dbName}]...`);

  const seedFiles = [
    'seed_notifications.sql',
    'seed_marketing_and_fixes.sql',
    'seed_permissions.sql'
  ];

  for (const file of seedFiles) {
    const filePath = path.join(__dirname, '..', 'db', 'seeds', file);
    if (!fs.existsSync(filePath)) continue;
    let sql = fs.readFileSync(filePath, 'utf8');
    if (sql.charCodeAt(0) === 0xFEFF) {
      sql = sql.slice(1);
    }
    try {
      await client.query(sql);
      console.log(`  ✓ Applied db/seeds/${file}`);
    } catch (err) {
      console.error(`  ❌ Failed db/seeds/${file}:`, err.message);
    }
  }

  await client.end();
}

async function main() {
  await applySeedsToDb('kapmeta');
  await applySeedsToDb('petpooja');
}

main().catch(console.error);
