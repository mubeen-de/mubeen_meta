const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const res = await c.query("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'menu_items' ORDER BY ordinal_position");
  console.log(JSON.stringify(res.rows, null, 2));
  await c.end();
})();
