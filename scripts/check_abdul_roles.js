const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const res = await c.query("SELECT * FROM user_roles WHERE user_id = 'd119207c-8cf7-4a03-8125-6737c85c210d'");
  console.log('user_roles for Abdul Mannan:', res.rows);
  const outlets = await c.query("SELECT id, name FROM outlets");
  console.log('outlets in db:', outlets.rows);
  await c.end();
})();
