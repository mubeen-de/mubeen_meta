const { Client } = require('pg');

async function dedupe() {
  const c = new Client({ connectionString: 'postgresql://pos:pos@localhost:5432/petpooja' });
  await c.connect();
  await c.query(`
    DELETE FROM ingredients a USING (
      SELECT MIN(ctid) as min_ctid, name, outlet_id
      FROM ingredients
      GROUP BY name, outlet_id
    ) b
    WHERE a.name = b.name AND a.outlet_id = b.outlet_id AND a.ctid <> b.min_ctid;
  `);
  const r = await c.query('SELECT count(*) FROM ingredients');
  console.log('petpooja ingredients count:', r.rows[0].count);
  await c.end();
}

dedupe().catch(console.error);
