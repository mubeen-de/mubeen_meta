const { Client } = require('pg');
const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
(async () => {
  await c.connect();
  const ur = await c.query(`
    SELECT ur.user_id, r.name as role_name, r.id as role_id 
    FROM user_roles ur 
    JOIN roles r ON ur.role_id = r.id 
    WHERE ur.user_id = 'd119207c-8cf7-4a03-8125-6737c85c210d'
  `);
  console.log('User roles:', ur.rows);

  const perms = await c.query(`
    SELECT DISTINCT p.name 
    FROM user_roles ur 
    JOIN role_permissions rp ON ur.role_id = rp.role_id 
    JOIN permissions p ON rp.permission_id = p.id 
    WHERE ur.user_id = 'd119207c-8cf7-4a03-8125-6737c85c210d'
    ORDER BY p.name
  `);
  console.log('User permissions count:', perms.rows.length);
  console.log('Has settings.manage?', perms.rows.some(r => r.name === 'settings.manage'));
  console.log('Has table.manage?', perms.rows.some(r => r.name === 'table.manage'));
  console.log('All permissions:', perms.rows.map(r => r.name));
  await c.end();
})();
