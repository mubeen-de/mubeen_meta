const { Client } = require('pg');

async function getAllColumns(dbName) {
  const c = new Client({ connectionString: `postgresql://pos:pos@localhost:5432/${dbName}` });
  await c.connect();
  const res = await c.query(`
    SELECT table_name, column_name, data_type, is_nullable
    FROM information_schema.columns
    WHERE table_schema = 'public'
    ORDER BY table_name, column_name;
  `);
  await c.end();

  const map = new Map();
  for (const row of res.rows) {
    if (!map.has(row.table_name)) map.set(row.table_name, new Set());
    map.get(row.table_name).add(row.column_name);
  }
  return map;
}

async function main() {
  const petpoojaCols = await getAllColumns('petpooja');
  const kapmetaCols = await getAllColumns('kapmeta');

  console.log('=== Comparing petpooja (source/working) vs kapmeta ===');

  let differencesFound = 0;

  for (const [table, cols] of petpoojaCols.entries()) {
    if (!kapmetaCols.has(table)) {
      console.log(`Table [${table}] exists in petpooja but MISSING in kapmeta!`);
      differencesFound++;
      continue;
    }
    const kCols = kapmetaCols.get(table);
    const missingInKapmeta = [...cols].filter(col => !kCols.has(col));
    if (missingInKapmeta.length > 0) {
      console.log(`Table [${table}]: missing columns in kapmeta -> ${missingInKapmeta.join(', ')}`);
      differencesFound++;
    }
  }

  for (const [table, cols] of kapmetaCols.entries()) {
    if (!petpoojaCols.has(table)) {
      console.log(`Table [${table}] exists in kapmeta but MISSING in petpooja!`);
      differencesFound++;
      continue;
    }
    const pCols = petpoojaCols.get(table);
    const missingInPetpooja = [...cols].filter(col => !pCols.has(col));
    if (missingInPetpooja.length > 0) {
      console.log(`Table [${table}]: missing columns in petpooja -> ${missingInPetpooja.join(', ')}`);
      differencesFound++;
    }
  }

  if (differencesFound === 0) {
    console.log('SUCCESS: All 97 tables and all columns are 100% identical between petpooja and kapmeta!');
  } else {
    console.log(`Total differences: ${differencesFound}`);
  }
}

main().catch(console.error);
