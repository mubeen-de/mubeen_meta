const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const roles = await c.query('SELECT * FROM roles');
  console.log('Roles:', roles.rows);
  const user = await c.query("SELECT id, name, email FROM users WHERE name ILIKE '%Abdul%'");
  console.log('Abdul user:', user.rows);
  const userRoles = await c.query("SELECT * FROM user_roles WHERE user_id = $1", [user.rows[0].id]);
  console.log('User roles:', userRoles.rows);
  await c.end();
})();
