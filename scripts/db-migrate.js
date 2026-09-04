// Applies db/migrations/*.sql in order, tracked in schema_migrations.
// Replaces the Prisma placeholder — the real schema is the raw SQL in db/migrations/,
// documented in docs/database/objects/DB-OBJECT-CATALOGUE.md. No ORM schema exists;
// do not reintroduce one without an ADR (see docs/ENGINEERING-PROTOCOL.md §6).
//
// schema_migrations is the table docs/12-operations/troubleshooting/TS-DB-database-issues.md
// already assumes exists — keep this name in sync if either changes.

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

// Ensure root .env is loaded if DATABASE_URL is not already in environment
const envPath = path.join(__dirname, '..', '.env');
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf8');
  envContent.split('\n').forEach((line) => {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith('#')) {
      const idx = trimmed.indexOf('=');
      if (idx !== -1) {
        const key = trimmed.slice(0, idx).trim();
        const val = trimmed.slice(idx + 1).trim();
        if (!process.env[key]) {
          process.env[key] = val;
        }
      }
    }
  });
}

const MIGRATIONS_DIR = path.join(__dirname, '..', 'db', 'migrations');

async function main() {
  const databaseUrl = process.env.DATABASE_URL || 'postgresql://pos:pos@localhost:5432/kapmeta';
  if (!databaseUrl) {
    console.error('[db:migrate] DATABASE_URL not set. Copy .env.example to .env first.');
    process.exit(1);
  }

  const files = fs
    .readdirSync(MIGRATIONS_DIR)
    .filter((f) => f.endsWith('.sql'))
    .sort(); // filenames are zero-padded (0001_, 0002_, ...) — lexicographic sort is correct order

  if (files.length === 0) {
    console.log('[db:migrate] No .sql migrations found in db/migrations/. Nothing to do.');
    return;
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (
        version      TEXT PRIMARY KEY,
        applied_at   TIMESTAMPTZ NOT NULL DEFAULT now()
      );
    `);

    const { rows: applied } = await client.query('SELECT version FROM schema_migrations');
    const appliedSet = new Set(applied.map((r) => r.version));

    let ranCount = 0;
    for (const file of files) {
      if (appliedSet.has(file)) {
        continue;
      }

      let sql = fs.readFileSync(path.join(MIGRATIONS_DIR, file), 'utf8');
      const downMarker = sql.indexOf('-- +migrate Down');
      if (downMarker !== -1) {
        sql = sql.substring(0, downMarker);
      }

      if (file === '0001_extensions_and_enums.sql') {
        sql = sql.replace(
          "'cancelled'",
          "'cancelled', 'DRAFT', 'PLACED', 'CONFIRMED', 'KOT_CREATED', 'IN_PREPARATION', 'READY', 'ASSIGNED', 'OUT_FOR_DELIVERY', 'SERVED', 'HANDED_OVER', 'COMPLETED', 'FAILED'"
        );
        sql += "\nCREATE TYPE order_type AS ENUM ('DINE_IN', 'PICKUP', 'DELIVERY');\n";
      }

      if (file === '0004_create_tables_and_sessions.sql') {
        sql += `
          CREATE TABLE IF NOT EXISTS dining_tables (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            outlet_id UUID NOT NULL REFERENCES outlets(id),
            table_number TEXT NOT NULL,
            capacity INTEGER DEFAULT 4,
            section TEXT DEFAULT 'General',
            status TEXT DEFAULT 'VACANT',
            is_active BOOLEAN DEFAULT true,
            created_at TIMESTAMPTZ DEFAULT now(),
            updated_at TIMESTAMPTZ DEFAULT now(),
            UNIQUE (outlet_id, table_number)
          );
        `;
      }

      if (file === '0004_orders.sql') {
        sql = sql.replace(/CREATE TYPE order_status AS ENUM \([^)]+\);/s, '');
        sql = sql.replace(/CREATE TYPE order_type AS ENUM \([^)]+\);/s, '');
      }

      if (file === '0005_create_menu_categories_and_items.sql') {
        sql = `
          CREATE TABLE IF NOT EXISTS menu_categories (
            id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
            outlet_id           uuid NOT NULL REFERENCES outlets (id) ON DELETE RESTRICT,
            name                text NOT NULL,
            online_display_name text NULL,
            sort_order          integer NOT NULL DEFAULT 0,
            is_active           boolean NOT NULL DEFAULT true,
            created_at          timestamptz NOT NULL DEFAULT now(),
            updated_at          timestamptz NOT NULL DEFAULT now()
          );
          CREATE UNIQUE INDEX IF NOT EXISTS ux_menu_categories_outlet_name ON menu_categories (outlet_id, name);
        `;
      }

      if (file === '0017_payment_idempotency.sql') {
        sql = `
          CREATE TABLE IF NOT EXISTS payments (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            outlet_id UUID,
            order_id UUID,
            amount BIGINT NOT NULL DEFAULT 0,
            method TEXT NOT NULL DEFAULT 'CASH',
            status TEXT NOT NULL DEFAULT 'CAPTURED',
            transaction_id TEXT,
            idempotency_key TEXT,
            created_at TIMESTAMPTZ NOT NULL DEFAULT now()
          );
        ` + sql;
      }

      if (file === '0019_add_channel_item_mapping_version.sql') {
        sql = 'ALTER TABLE channel_item_mapping ADD COLUMN IF NOT EXISTS channel_code VARCHAR(50);\n' + sql;
      }

      if (file === '0029_table_merge_groups_and_members.sql') {
        sql = sql.replace(/'ACTIVE'/g, "'ACTIVE'::table_merge_status");
      }

      console.log(`[db:migrate] applying ${file} ...`);

      try {
        await client.query(sql);
        await client.query('INSERT INTO schema_migrations (version) VALUES ($1) ON CONFLICT DO NOTHING', [file]);
        console.log(`[db:migrate] applied ${file}`);
        ranCount += 1;
      } catch (err) {
        await client.query('ROLLBACK').catch(() => {});
        // Only "the object is already there" is a safe no-op. Every other failure means the
        // migration genuinely did NOT apply, and recording it as applied is how this database
        // ended up half-built: migration 0022 rolled back on a missing table, was marked done,
        // and outbox_events / inventory_consumption_log have been throwing ever since.
        // 42P07 duplicate_table, 42710 duplicate_object, 42701 duplicate_column,
        // 42P06 duplicate_schema, 42723 duplicate_function
        const ALREADY_PRESENT = ['42P07', '42710', '42701', '42P06', '42723'];
        if (ALREADY_PRESENT.includes(err && err.code)) {
          console.log(`[db:migrate] ${file}: schema objects already present (${err.code}). Recorded migration state.`);
          await client.query('INSERT INTO schema_migrations (version) VALUES ($1) ON CONFLICT DO NOTHING', [file]);
        } else {
          console.error(`[db:migrate] ${file} FAILED and was NOT recorded as applied.`);
          console.error(`[db:migrate]   ${err && err.code ? err.code + ': ' : ''}${err && err.message}`);
          if (err && err.detail) console.error(`[db:migrate]   detail: ${err.detail}`);
          if (err && err.hint) console.error(`[db:migrate]   hint: ${err.hint}`);
          throw err;
        }
      }
    }

    if (ranCount === 0) {
      console.log('[db:migrate] Database already up to date.');
    } else {
      console.log(`[db:migrate] Applied ${ranCount} migration(s).`);
    }
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[db:migrate] Unexpected error:', err);
  process.exit(1);
});
