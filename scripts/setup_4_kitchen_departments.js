const { Client } = require('pg');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.resolve(__dirname, '../.env') });
dotenv.config();

const databaseUrl = process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/kapmeta';

const FOUR_DEPARTMENTS = [
  {
    name: 'Chinese Kitchen',
    code: 'CHINESE',
    printerIp: '192.168.1.101',
    slaWarning: 480,  // 8 mins
    slaBreach: 720,   // 12 mins
    categories: [
      'chinese', 'soup', 'staters ni', 'noodle', 'fried rice', 'manchurian', 'spring roll', 'momos'
    ]
  },
  {
    name: 'Continental & Cafe',
    code: 'CONTINENTAL_CAFE',
    printerIp: '192.168.1.102',
    slaWarning: 360,  // 6 mins
    slaBreach: 600,   // 10 mins
    categories: [
      'pizza', 'burger', 'sandwich', 'garlic bread', 'pasta', 'fries', 'frankie',
      'shake', 'mocktail', 'coffee', 'beverge', 'beverage', 'hot beverage', 'cold beverage'
    ]
  },
  {
    name: 'Indian & Tandoor',
    code: 'INDIAN_MAIN',
    printerIp: '192.168.1.103',
    slaWarning: 600,  // 10 mins
    slaBreach: 900,   // 15 mins
    categories: [
      'biryani', 'curries', 'curry', 'tandoor', 'roti', 'naan', 'bread', 'flavour rice',
      'thali', 'meal', 'rice bowl', 'meal box', 'combo', 'paneer', 'dal', 'gravy', 'subji', 'sabji'
    ]
  },
  {
    name: 'South Indian & Pantry',
    code: 'SOUTH_INDIAN',
    printerIp: '192.168.1.104',
    slaWarning: 300,  // 5 mins
    slaBreach: 540,   // 9 mins
    categories: [
      'dosa', 'breakfast', 'idli', 'vada', 'chat', 'dessert', 'falooda', 'softy',
      'ice cream', 'butter milk', 'lassi', 'cookie', 'cookies', 'parcel', 'extra'
    ]
  }
];

function matchDepartment(catName, itemName) {
  const target = ` ${catName || ''} ${itemName || ''} `.toLowerCase();

  const matchesKeyword = (kw) => {
    if (kw.includes(' ')) {
      return target.includes(kw.toLowerCase());
    }
    const escaped = kw.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`\\b${escaped}\\b`, 'i');
    return regex.test(target);
  };

  // 1. Chinese
  for (const kw of FOUR_DEPARTMENTS[0].categories) {
    if (matchesKeyword(kw)) return 'CHINESE';
  }

  // 2. Continental / Cafe
  for (const kw of FOUR_DEPARTMENTS[1].categories) {
    if (matchesKeyword(kw)) return 'CONTINENTAL_CAFE';
  }

  // 3. Indian / Tandoor
  for (const kw of FOUR_DEPARTMENTS[2].categories) {
    if (matchesKeyword(kw)) return 'INDIAN_MAIN';
  }

  // 4. South Indian / Pantry
  for (const kw of FOUR_DEPARTMENTS[3].categories) {
    if (matchesKeyword(kw)) return 'SOUTH_INDIAN';
  }

  return 'INDIAN_MAIN'; // fallback
}

async function setupDepartments() {
  const client = new Client({ connectionString: databaseUrl });
  try {
    await client.connect();
    console.log('[KITCHEN DEPT] Connected to database.');

    const outlets = await client.query('SELECT id, name FROM outlets');
    console.log(`[KITCHEN DEPT] Found ${outlets.rows.length} outlets.`);

    for (const outlet of outlets.rows) {
      console.log(`\n--- Setting up 4 departments for: ${outlet.name} (${outlet.id}) ---`);
      const stationMap = new Map();

      for (const dept of FOUR_DEPARTMENTS) {
        // Upsert or fetch station
        const check = await client.query(
          'SELECT id FROM stations WHERE outlet_id = $1 AND (name = $2 OR name = $3)',
          [outlet.id, dept.name, dept.code]
        );

        let stationId;
        if (check.rows.length > 0) {
          stationId = check.rows[0].id;
          await client.query(
            'UPDATE stations SET name = $1, printer_ip = $2, sla_warning_seconds = $3, sla_breach_seconds = $4, updated_at = NOW() WHERE id = $5',
            [dept.name, dept.printerIp, dept.slaWarning, dept.slaBreach, stationId]
          );
        } else {
          const inserted = await client.query(
            `INSERT INTO stations (id, outlet_id, name, printer_ip, sla_warning_seconds, sla_breach_seconds, created_at, updated_at)
             VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, NOW(), NOW()) RETURNING id`,
            [outlet.id, dept.name, dept.printerIp, dept.slaWarning, dept.slaBreach]
          );
          stationId = inserted.rows[0].id;
        }

        stationMap.set(dept.code, stationId);
        console.log(`  ✓ Station ready: [${dept.code}] "${dept.name}" -> ID: ${stationId}`);
      }

      // Map menu items for this outlet to the appropriate station
      const itemsRes = await client.query(`
        SELECT mi.id, mi.name, c.name as category_name
        FROM menu_items mi
        LEFT JOIN menu_categories c ON mi.category_id = c.id
        WHERE mi.outlet_id = $1
      `, [outlet.id]);

      let updatedCount = 0;
      for (const item of itemsRes.rows) {
        const deptCode = matchDepartment(item.category_name, item.name);
        const targetStationId = stationMap.get(deptCode);
        if (targetStationId) {
          await client.query('UPDATE menu_items SET station_id = $1 WHERE id = $2', [targetStationId, item.id]);
          updatedCount++;
        }
      }

      console.log(`  ✓ Mapped ${updatedCount} menu items to their designated department station.`);
    }

    console.log('\n[KITCHEN DEPT] ✓ All 4 kitchen departments and item mappings configured successfully!');
  } catch (err) {
    console.error('[KITCHEN DEPT ERROR]', err);
  } finally {
    await client.end().catch(() => {});
  }
}

if (require.main === module) {
  setupDepartments();
}

module.exports = { setupDepartments, FOUR_DEPARTMENTS, matchDepartment };
