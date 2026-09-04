const fs = require('fs');
const { Client } = require('pg');

const modelsToCheck = [
  'Organization',
  'Outlet',
  'Terminal',
  'DiningTable',
  'Station',
  'User',
  'Role',
  'UserRole',
  'MenuCategory',
  'MenuItem',
  'ItemAvailability',
  'Ingredient',
  'Customer',
  'Recipe',
  'RecipeIngredient',
  'Vendor',
  'LedgerEntry'
];

async function inspect(dbName) {
  const schemaContent = fs.readFileSync('node_modules/.prisma/client/schema.prisma', 'utf8');
  const client = new Client({ connectionString: `postgresql://pos:pos@localhost:5432/${dbName}` });
  await client.connect();

  console.log(`\n================ Checking Database [${dbName}] ================`);

  for (const modelName of modelsToCheck) {
    const regex = new RegExp(`model\\s+${modelName}\\s+\\{([\\s\\S]*?)\\}`, 'm');
    const match = schemaContent.match(regex);
    if (!match) {
      console.log(`Model ${modelName} not found in node_modules/.prisma/client/schema.prisma`);
      continue;
    }

    const body = match[1];
    let tableName = modelName.toLowerCase();
    const mapMatch = body.match(/@@map\("([^"]+)"\)/);
    if (mapMatch) tableName = mapMatch[1];

    // Check table existence
    const tblRes = await client.query(
      `SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name = $1`,
      [tableName]
    );
    if (tblRes.rows.length === 0) {
      console.log(`❌ Table [${tableName}] for model [${modelName}] MISSING!`);
      continue;
    }

    // Get live columns
    const colRes = await client.query(
      `SELECT column_name FROM information_schema.columns WHERE table_schema = 'public' AND table_name = $1`,
      [tableName]
    );
    const liveCols = new Set(colRes.rows.map(r => r.column_name));

    // Extract scalar fields from Prisma model
    const lines = body.split('\n');
    const missingCols = [];
    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('//') || trimmed.startsWith('@@')) continue;
      const parts = trimmed.split(/\s+/);
      const fieldName = parts[0];
      const fieldType = parts[1];
      // Skip relation fields
      if (!fieldType || /^[A-Z]/.test(fieldType)) continue;

      let colName = fieldName;
      const colMapMatch = trimmed.match(/@map\("([^"]+)"\)/);
      if (colMapMatch) colName = colMapMatch[1];

      if (!liveCols.has(colName)) {
        missingCols.push(colName);
      }
    }

    if (missingCols.length > 0) {
      console.log(`⚠️ Table [${tableName}] (${modelName}): missing columns -> ${missingCols.join(', ')}`);
    } else {
      console.log(`✓ Table [${tableName}] (${modelName}): all fields match.`);
    }
  }

  await client.end();
}

async function main() {
  await inspect('kapmeta');
  await inspect('petpooja');
}

main().catch(console.error);
