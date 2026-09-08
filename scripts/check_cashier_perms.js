const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const res = await c.query(`
    SELECT p.code, p.action, p.description 
    FROM role_permissions rp 
    JOIN permissions p ON rp.permission_id = p.id 
    WHERE rp.role_id = '11111111-1111-1111-1111-111111111104'
    ORDER BY p.code
  `);
  console.log('Cashier permissions count:', res.rows.length);
  console.log('Cashier permissions:', res.rows.map(r => r.code || r.action));
  await c.end();
})();
