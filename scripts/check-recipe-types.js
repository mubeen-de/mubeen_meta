const { Client } = require('pg');

async function main() {
  const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/kapmeta' });
  await c.connect();
  const res = await c.query(`
    SELECT column_name, data_type, is_nullable, column_default
    FROM information_schema.columns
    WHERE table_name = 'recipe_ingredients';
  `);
  console.log(res.rows);
  await c.end();
}

main().catch(console.error);
