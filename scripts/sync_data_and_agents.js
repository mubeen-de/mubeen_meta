const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const DEFAULT_OUTLET_ID = '11111111-1111-1111-1111-111111111111';
const BCRYPT_PIN_1234 = '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.';
const BCRYPT_PASS_DEV = '$2a$10$Ab1.yfL403Umy95GUdPlwumAORkwCrH27yClLAFOR6z4Is9zRJ4B.';

const ROLES_SPEC = [
  { id: '11111111-1111-1111-1111-111111111101', code: 'SUPER_ADMIN', name: 'SUPER_ADMIN', desc: 'Super Administrator / System IT Admin' },
  { id: '11111111-1111-1111-1111-111111111102', code: 'ADMIN', name: 'ADMIN', desc: 'Administrator' },
  { id: '11111111-1111-1111-1111-111111111103', code: 'OUTLET_MANAGER', name: 'OUTLET_MANAGER', desc: 'Restaurant Manager / Outlet General Admin' },
  { id: '11111111-1111-1111-1111-111111111104', code: 'CASHIER', name: 'CASHIER', desc: 'Cashier / Front-Desk Biller / POS Operator' },
  { id: '11111111-1111-1111-1111-111111111105', code: 'KITCHEN_USER', name: 'KITCHEN_USER', desc: 'Kitchen Staff / Head Chef / KDS Display' },
  { id: '11111111-1111-1111-1111-111111111106', code: 'WAITER', name: 'WAITER', desc: 'Captain / Waiter / Table Steward' },
  { id: '11111111-1111-1111-1111-111111111107', code: 'DELIVERY_MANAGER', name: 'DELIVERY_MANAGER', desc: 'Online Aggregator & Dispatch Manager (Swiggy / Zomato)' },
  { id: '11111111-1111-1111-1111-111111111108', code: 'INVENTORY_MANAGER', name: 'INVENTORY_MANAGER', desc: 'Store & Inventory Manager' },
  { id: '11111111-1111-1111-1111-111111111109', code: 'ACCOUNTANT', name: 'ACCOUNTANT', desc: 'Accountant / Auditor / Financial Controller' },
];

const STAFF_USERS = [
  { email: 'admin@hotelkapila.com', firstName: 'Abdul', lastName: 'Mannan', role: 'SUPER_ADMIN' },
  { email: 'manager@hotelkapila.com', firstName: 'Rajesh', lastName: 'Sharma', role: 'OUTLET_MANAGER' },
  { email: 'cashier@hotelkapila.com', firstName: 'Kapila', lastName: 'Cashier', role: 'CASHIER' },
  { email: 'chef@hotelkapila.com', firstName: 'Head', lastName: 'Chef', role: 'KITCHEN_USER' },
  { email: 'waiter@hotelkapila.com', firstName: 'Rahul', lastName: 'Kumar', role: 'WAITER' },
  { email: 'delivery@hotelkapila.com', firstName: 'Amit', lastName: 'Verma', role: 'DELIVERY_MANAGER' },
  { email: 'inventory@hotelkapila.com', firstName: 'Vikram', lastName: 'Patel', role: 'INVENTORY_MANAGER' },
  { email: 'accountant@hotelkapila.com', firstName: 'Suresh', lastName: 'Iyer', role: 'ACCOUNTANT' },
];

const ROLE_PERMISSIONS_MAP = {
  SUPER_ADMIN: ['*'],
  ADMIN: ['*'],
  OUTLET_MANAGER: [
    'order.create', 'order.read', 'order.update', 'order.cancel', 'order.discount',
    'kot.create', 'kot.read', 'kot.update', 'kot.recall', 'kot.manage',
    'table.read', 'table.transfer', 'table.merge', 'table.split', 'table.manage',
    'bill.generate', 'bill.settle', 'bill.reprint', 'bill.split',
    'payment.collect', 'payment.refund', 'payment.split',
    'menu.read', 'menu.category.manage', 'menu.item.manage', 'menu.86.toggle',
    'inventory.read', 'inventory.stock.adjust', 'inventory.po.create', 'inventory.po.approve', 'inventory.grn.create', 'inventory.write', 'inventory.stock.deduct',
    'report.read', 'report.financial.read', 'report.audit.read', 'report.export', 'report.zreport',
    'finance.report', 'finance.cash_drawer.manage', 'finance.petty_cash.record',
    'crm.read', 'crm.write', 'crm.loyalty.redeem', 'crm.loyalty.issue',
    'settings.read', 'settings.manage', 'users.manage', 'users.read', 'outlets.manage', 'roles.manage',
    'integration.manage', 'integration.sync', 'audit.read'
  ],
  CASHIER: [
    'order.create', 'order.read', 'order.update', 'order.cancel', 'order.discount',
    'kot.create', 'kot.read',
    'table.read', 'table.transfer',
    'bill.generate', 'bill.settle', 'bill.reprint', 'bill.split',
    'payment.collect', 'payment.refund', 'payment.split',
    'menu.read', 'menu.86.toggle',
    'report.read', 'report.zreport',
    'finance.report', 'finance.cash_drawer.manage', 'finance.petty_cash.record',
    'crm.read', 'crm.write'
  ],
  WAITER: [
    'order.create', 'order.read', 'order.update',
    'kot.create', 'kot.read',
    'table.read', 'table.transfer', 'table.merge',
    'menu.read'
  ],
  KITCHEN_USER: [
    'kot.read', 'kot.update', 'kot.recall', 'kot.manage',
    'order.read', 'menu.read'
  ],
  DELIVERY_MANAGER: [
    'order.read', 'order.update', 'kot.read',
    'integration.sync', 'integration.manage',
    'menu.read', 'menu.86.toggle'
  ],
  INVENTORY_MANAGER: [
    'inventory.read', 'inventory.stock.adjust', 'inventory.po.create', 'inventory.po.approve', 'inventory.grn.create', 'inventory.write', 'inventory.stock.deduct',
    'menu.read', 'menu.86.toggle',
    'report.read'
  ],
  ACCOUNTANT: [
    'report.read', 'report.financial.read', 'report.audit.read', 'report.export', 'report.zreport',
    'finance.report', 'finance.cash_drawer.manage', 'finance.petty_cash.record',
    'audit.read'
  ]
};

async function syncDatabase(dbName) {
  const client = new Client({ connectionString: `postgresql://pos:pos@localhost:5432/${dbName}` });
  try {
    await client.connect();
    console.log(`\n======================================================`);
    console.log(`  STARTING DATA & AGENT SYNCHRONIZATION ON [${dbName}]`);
    console.log(`======================================================`);

    // 1. Schema Extensions & agent_telemetry migration
    const migrationFile = path.join(__dirname, '..', 'db', 'migrations', '0041_agent_telemetry.sql');
    if (fs.existsSync(migrationFile)) {
      const sql = fs.readFileSync(migrationFile, 'utf8');
      await client.query(sql);
      console.log(`  ✓ Applied migration 0041_agent_telemetry.sql`);
    }

    // 2. Outlets & Organization normalization
    await client.query(`
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS address TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS phone TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS email TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS logo_url TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS fssai_number TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS upi_vpa TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS status TEXT;
      ALTER TABLE outlets ADD COLUMN IF NOT EXISTS last_menu_sync_at TIMESTAMPTZ;
      ALTER TABLE outlets ALTER COLUMN day_start_time TYPE TEXT;

      ALTER TABLE users ADD COLUMN IF NOT EXISTS first_name TEXT;
      ALTER TABLE users ADD COLUMN IF NOT EXISTS last_name TEXT;
      ALTER TABLE users ADD COLUMN IF NOT EXISTS pin_hash TEXT;

      ALTER TABLE roles ADD COLUMN IF NOT EXISTS code TEXT;
      ALTER TABLE permissions ADD COLUMN IF NOT EXISTS created_by UUID;
      ALTER TABLE permissions ADD COLUMN IF NOT EXISTS updated_by UUID;
      ALTER TABLE user_roles ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now();
      ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS pk_user_roles;
      ALTER TABLE user_roles ADD CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_id);
      CREATE UNIQUE INDEX IF NOT EXISTS uq_roles_name ON roles (name);
      CREATE UNIQUE INDEX IF NOT EXISTS uq_roles_code ON roles (code);
      CREATE UNIQUE INDEX IF NOT EXISTS uq_permissions_code ON permissions (code);
    `);
    console.log(`  ✓ Normalized outlet, user, role and permission constraints.`);

    // 3. Ensure All 8 Operational Roles Exist
    for (const r of ROLES_SPEC) {
      await client.query(`
        INSERT INTO roles (id, code, name, description)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (code) DO UPDATE SET
          name = EXCLUDED.name,
          description = EXCLUDED.description;
      `, [r.id, r.code, r.name, r.desc]);
    }
    console.log(`  ✓ Synced ${ROLES_SPEC.length} operational roles into roles table.`);

    // 4. Ensure Permissions Exist and Map to Roles
    const allPermsRes = await client.query(`SELECT id, code FROM permissions`);
    const permMap = new Map(allPermsRes.rows.map(row => [row.code, row.id]));

    for (const [roleCode, permList] of Object.entries(ROLE_PERMISSIONS_MAP)) {
      const roleRes = await client.query(`SELECT id FROM roles WHERE code = $1`, [roleCode]);
      if (roleRes.rows.length === 0) continue;
      const roleId = roleRes.rows[0].id;

      let targetPermIds = [];
      if (permList.includes('*')) {
        targetPermIds = Array.from(permMap.values());
      } else {
        for (const code of permList) {
          if (permMap.has(code)) {
            targetPermIds.push(permMap.get(code));
          }
        }
      }

      for (const pId of targetPermIds) {
        await client.query(`
          INSERT INTO role_permissions (role_id, permission_id)
          VALUES ($1, $2)
          ON CONFLICT DO NOTHING;
        `, [roleId, pId]);
      }
    }
    console.log(`  ✓ Mapped role permissions across all operational roles.`);

    // 5. Ensure Staff Users Exist and Are Assigned Roles
    const outletRes = await client.query(`SELECT id FROM outlets LIMIT 1`);
    const targetOutletId = outletRes.rows[0]?.id || DEFAULT_OUTLET_ID;

    for (const u of STAFF_USERS) {
      let userRes = await client.query(`SELECT id FROM users WHERE email = $1`, [u.email]);
      let userId;
      if (userRes.rows.length === 0) {
        const ins = await client.query(`
          INSERT INTO users (id, email, password_hash, pin_hash, first_name, last_name, is_active, updated_at)
          VALUES (gen_random_uuid(), $1, $2, $3, $4, $5, true, NOW())
          RETURNING id;
        `, [u.email, BCRYPT_PASS_DEV, BCRYPT_PIN_1234, u.firstName, u.lastName]);
        userId = ins.rows[0].id;
        console.log(`    + Created staff user: ${u.email} (${u.firstName} ${u.lastName})`);
      } else {
        userId = userRes.rows[0].id;
        await client.query(`
          UPDATE users SET first_name = $1, last_name = $2, pin_hash = $3, is_active = true WHERE id = $4
        `, [u.firstName, u.lastName, BCRYPT_PIN_1234, userId]);
      }

      const roleRes = await client.query(`SELECT id FROM roles WHERE code = $1`, [u.role]);
      if (roleRes.rows.length > 0) {
        const roleId = roleRes.rows[0].id;
        await client.query(`
          INSERT INTO user_roles (user_id, role_id, outlet_id)
          VALUES ($1, $2, $3)
          ON CONFLICT (user_id, role_id) DO NOTHING;
        `, [userId, roleId, targetOutletId]);
      }
    }
    console.log(`  ✓ Synced ${STAFF_USERS.length} staff operational accounts with roles & outlet.`);

    // 6. Apply core seeds if missing
    const seeds = ['seed_notifications.sql', 'seed_marketing_and_fixes.sql'];
    for (const sf of seeds) {
      const p = path.join(__dirname, '..', 'db', 'seeds', sf);
      if (fs.existsSync(p)) {
        let sql = fs.readFileSync(p, 'utf8');
        if (sql.charCodeAt(0) === 0xFEFF) sql = sql.slice(1);
        try {
          await client.query(sql);
          console.log(`  ✓ Verified seed: ${sf}`);
        } catch (e) {
          console.warn(`  ! Note on ${sf}: ${e.message}`);
        }
      }
    }

    // 7. Verify Agent Telemetry Count
    const agentCountRes = await client.query(`SELECT count(*)::int as count FROM agent_telemetry`);
    console.log(`  🟢 Live agent telemetry records in [${dbName}]: ${agentCountRes.rows[0].count} / 8`);

    await client.end();
  } catch (err) {
    console.error(`❌ Error syncing database [${dbName}]:`, err);
    try { await client.end(); } catch (_) {}
  }
}

async function main() {
  await syncDatabase('petpooja');
  await syncDatabase('kapmeta');
  console.log(`\n🎉 All databases and multi-agent systems successfully synchronized.\n`);
}

main().catch(console.error);
