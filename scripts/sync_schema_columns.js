const fs = require('fs');
const { Client } = require('pg');

async function syncSchemaForDb(dbName) {
  const client = new Client({ connectionString: `postgresql://pos:pos@localhost:5432/${dbName}` });
  await client.connect();

  console.log(`Synchronizing schema columns for Prisma compatibility on [${dbName}]...`);

  // Outlets missing columns
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
    CREATE UNIQUE INDEX IF NOT EXISTS uq_outlets_code ON outlets (code);
  `);

  // Organizations missing columns
  await client.query(`
    ALTER TABLE organizations ADD COLUMN IF NOT EXISTS tax_number TEXT;
    UPDATE organizations SET tax_number = tax_id WHERE tax_number IS NULL AND tax_id IS NOT NULL;
  `);

  // Users missing columns
  await client.query(`
    ALTER TABLE users ADD COLUMN IF NOT EXISTS first_name TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS last_name TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS pin_hash TEXT;
  `);

  // Terminals table
  await client.query(`
    CREATE TABLE IF NOT EXISTS terminals (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      outlet_id UUID NOT NULL REFERENCES outlets(id),
      terminal_number TEXT NOT NULL,
      name TEXT NOT NULL,
      is_active BOOLEAN DEFAULT true,
      created_by UUID,
      updated_by UUID,
      created_at TIMESTAMPTZ DEFAULT now(),
      updated_at TIMESTAMPTZ DEFAULT now(),
      UNIQUE (outlet_id, terminal_number)
    );
    ALTER TABLE terminals ADD COLUMN IF NOT EXISTS created_by UUID;
    ALTER TABLE terminals ADD COLUMN IF NOT EXISTS updated_by UUID;
  `);

  // Stations table
  await client.query(`
    CREATE TABLE IF NOT EXISTS stations (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      outlet_id UUID NOT NULL REFERENCES outlets(id),
      name TEXT NOT NULL,
      printer_ip TEXT,
      sla_warning_seconds INTEGER DEFAULT 300,
      sla_breach_seconds INTEGER DEFAULT 600,
      created_by UUID,
      updated_by UUID,
      created_at TIMESTAMPTZ DEFAULT now(),
      updated_at TIMESTAMPTZ DEFAULT now()
    );
    ALTER TABLE stations ADD COLUMN IF NOT EXISTS sla_warning_seconds INTEGER DEFAULT 300;
    ALTER TABLE stations ADD COLUMN IF NOT EXISTS sla_breach_seconds INTEGER DEFAULT 600;
    ALTER TABLE stations ADD COLUMN IF NOT EXISTS created_by UUID;
    ALTER TABLE stations ADD COLUMN IF NOT EXISTS updated_by UUID;
  `);

  // Users and Roles unique constraints & defaults
  await client.query(`
    ALTER TABLE users ALTER COLUMN full_name DROP NOT NULL;
    ALTER TABLE users ALTER COLUMN full_name SET DEFAULT '';
    CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email ON users (email);
    ALTER TABLE roles ADD COLUMN IF NOT EXISTS code TEXT;
    ALTER TABLE roles ADD COLUMN IF NOT EXISTS created_by UUID;
    ALTER TABLE roles ADD COLUMN IF NOT EXISTS updated_by UUID;
    ALTER TABLE permissions ADD COLUMN IF NOT EXISTS created_by UUID;
    ALTER TABLE permissions ADD COLUMN IF NOT EXISTS updated_by UUID;
    ALTER TABLE user_roles ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now();
    ALTER TABLE user_roles ADD COLUMN IF NOT EXISTS created_by UUID;
    ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS pk_user_roles;
    ALTER TABLE user_roles ADD CONSTRAINT pk_user_roles PRIMARY KEY (user_id, role_id);
    CREATE UNIQUE INDEX IF NOT EXISTS uq_roles_name ON roles (name);
    CREATE UNIQUE INDEX IF NOT EXISTS uq_roles_code ON roles (code);

    INSERT INTO roles (id, name, code, description) VALUES
      ('11111111-1111-1111-1111-111111111101', 'SUPER_ADMIN', 'SUPER_ADMIN', 'Super Administrator'),
      ('11111111-1111-1111-1111-111111111102', 'ADMIN', 'ADMIN', 'Administrator'),
      ('11111111-1111-1111-1111-111111111103', 'OUTLET_MANAGER', 'OUTLET_MANAGER', 'Outlet Manager'),
      ('11111111-1111-1111-1111-111111111104', 'CASHIER', 'CASHIER', 'Cashier'),
      ('11111111-1111-1111-1111-111111111105', 'KITCHEN_USER', 'KITCHEN_USER', 'Chef / Kitchen Display'),
      ('11111111-1111-1111-1111-111111111106', 'WAITER', 'WAITER', 'Waiter Staff')
    ON CONFLICT (name) DO NOTHING;
  `);

  // Dining tables missing columns
  await client.query(`
    ALTER TABLE dining_tables ADD COLUMN IF NOT EXISTS created_by UUID;
    ALTER TABLE dining_tables ADD COLUMN IF NOT EXISTS updated_by UUID;
  `);

  // Menu items columns & foreign key alignment
  await client.query(`
    ALTER TABLE menu_categories ADD COLUMN IF NOT EXISTS description TEXT;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS online_display_name TEXT;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS description TEXT;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS is_veg BOOLEAN DEFAULT true;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS tax_rate NUMERIC(5,2) DEFAULT 5.00;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS price BIGINT DEFAULT 0;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS stock_qty INTEGER DEFAULT 100;
    ALTER TABLE menu_items ADD COLUMN IF NOT EXISTS station_id UUID REFERENCES stations(id);

    ALTER TABLE menu_items DROP CONSTRAINT IF EXISTS menu_items_category_id_fkey;
    ALTER TABLE menu_items ADD CONSTRAINT menu_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE CASCADE;

    INSERT INTO categories (id, outlet_id, name, sort_order, is_active)
    SELECT id, outlet_id, name, sort_order, is_active FROM menu_categories
    ON CONFLICT (id) DO NOTHING;

    CREATE TABLE IF NOT EXISTS item_availabilities (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      outlet_id UUID NOT NULL REFERENCES outlets(id),
      menu_item_id UUID NOT NULL REFERENCES menu_items(id),
      is_stocked BOOLEAN NOT NULL DEFAULT true,
      stock_qty INTEGER NOT NULL DEFAULT 100,
      version INTEGER NOT NULL DEFAULT 1,
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      UNIQUE (outlet_id, menu_item_id)
    );

    INSERT INTO item_availabilities (id, outlet_id, menu_item_id, is_stocked, stock_qty, version, updated_at)
    SELECT gen_random_uuid(), m.outlet_id, m.id, true, 100, 1, now()
    FROM menu_items m
    LEFT JOIN item_availabilities a ON a.menu_item_id = m.id AND a.outlet_id = m.outlet_id
    WHERE a.id IS NULL
    ON CONFLICT (outlet_id, menu_item_id) DO NOTHING;
  `);

  // Ingredients columns
  await client.query(`
    ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS current_stock DECIMAL DEFAULT 0;
    ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS unit_cost BIGINT DEFAULT 0;
    ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS reorder_level DECIMAL DEFAULT 0;
    ALTER TABLE ingredients ALTER COLUMN reorder_level TYPE NUMERIC;
  `);

  // Recipes & Recipe Ingredients alignment
  await client.query(`
    ALTER TABLE recipes ALTER COLUMN name DROP NOT NULL;
    ALTER TABLE recipes ALTER COLUMN name SET DEFAULT '';
    ALTER TABLE recipe_ingredients ADD COLUMN IF NOT EXISTS yield_percent NUMERIC DEFAULT 100;
    ALTER TABLE recipe_ingredients ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();
  `);

  // Customers columns
  await client.query(`
    ALTER TABLE customers ALTER COLUMN organization_id DROP NOT NULL;
    ALTER TABLE customers ADD COLUMN IF NOT EXISTS outlet_id UUID;
    ALTER TABLE customers ADD COLUMN IF NOT EXISTS first_name TEXT;
    ALTER TABLE customers ADD COLUMN IF NOT EXISTS last_name TEXT;
    ALTER TABLE customers ADD COLUMN IF NOT EXISTS loyalty_points INTEGER DEFAULT 0;
    CREATE UNIQUE INDEX IF NOT EXISTS uq_customers_phone ON customers (phone);
  `);

  // Vendors columns
  await client.query(`
    ALTER TABLE vendors ADD COLUMN IF NOT EXISTS phone TEXT;
    ALTER TABLE vendors ADD COLUMN IF NOT EXISTS email TEXT;
    ALTER TABLE vendors ADD COLUMN IF NOT EXISTS tax_number TEXT;
    ALTER TABLE vendors ADD COLUMN IF NOT EXISTS contact_person TEXT;
    ALTER TABLE vendors ADD COLUMN IF NOT EXISTS address TEXT;
  `);

  // Ledger entries table
  await client.query(`
    CREATE TABLE IF NOT EXISTS ledger_entries (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      outlet_id UUID NOT NULL REFERENCES outlets(id),
      source_type TEXT NOT NULL,
      source_id TEXT NOT NULL,
      account TEXT NOT NULL,
      debit_minor BIGINT NOT NULL DEFAULT 0,
      credit_minor BIGINT NOT NULL DEFAULT 0,
      external_ref TEXT,
      status TEXT NOT NULL DEFAULT 'POSTED',
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      posted_at TIMESTAMPTZ
    );
    CREATE INDEX IF NOT EXISTS idx_ledger_entries_outlet ON ledger_entries(outlet_id);
    CREATE INDEX IF NOT EXISTS idx_ledger_entries_account ON ledger_entries(account);
  `);

  console.log(`Schema alignment complete for [${dbName}]!`);
  await client.end();
}

async function main() {
  await syncSchemaForDb('kapmeta');
  await syncSchemaForDb('petpooja');
}

main().catch((err) => {
  console.error('Error during schema sync:', err);
  process.exit(1);
});
