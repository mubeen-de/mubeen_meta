const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const res = await c.query("SELECT * FROM user_roles WHERE user_id = '4bc4d34d-f0d4-4402-ae14-2ab128803657'");
  console.log('user_roles for Cashier:', res.rows);
  const roles = await c.query("SELECT * FROM roles WHERE id = $1", [res.rows[0]?.role_id]);
  console.log('role for Cashier:', roles.rows);
  await c.end();
})();
