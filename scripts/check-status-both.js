const { Client } = require('pg');

async function checkDetailed(name) {
  const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/' + name });
  try {
    await c.connect();
    const tables = [
      'organizations', 'outlets', 'users', 'roles', 'permissions', 'role_permissions', 'user_roles',
      'stations', 'dining_tables', 'menu_categories', 'menu_items', 'item_availabilities',
      'ingredients', 'recipes', 'recipe_ingredients', 'vendors', 'customers', 'ledger_entries',
      'notifications', 'marketing_campaigns', 'channel_accounts', 'channel_item_mapping'
    ];
    const counts = {};
    for (const t of tables) {
      try {
        const res = await c.query(`SELECT count(*) FROM ${t}`);
        counts[t] = res.rows[0].count;
      } catch (e) {
        counts[t] = 'missing';
      }
    }
    console.log(`[${name}]:`, counts);
    await c.end();
  } catch (err) {
    console.error(`Error connecting to [${name}]:`, err.message);
  }
}

async function main() {
  await checkDetailed('petpooja');
  await checkDetailed('kapmeta');
}

main();
