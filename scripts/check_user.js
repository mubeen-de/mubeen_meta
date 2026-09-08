const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const res = await c.query("SELECT id, email, first_name, last_name, is_active FROM users");
  console.log(JSON.stringify(res.rows, null, 2));
  await c.end();
})();
