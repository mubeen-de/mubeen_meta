# Database Backups & Restoration Guide (Sep 14)

This directory contains full database SQL dumps of the active PetPooja / KapMeta POS platform as of September 14, 2026.

## Included Files

- `kapmeta_backup_sep14.sql`: Full SQL schema, all 105 tables, enum types, indexes, and live records (users, roles, permissions, menus, categories, tables, orders, KOTs, invoices, payments, audit logs, and operational data) exported from active `kapmeta` database.
- `petpooja_backup_sep14.sql`: Backup snapshot from `petpooja` database.

## Quick Restoration

### Method 1: Using the Batch Utility
Run the root batch file:
```cmd
.\Restore_Database.bat
```

### Method 2: Using psql CLI
```bash
# Ensure database exists
psql -h localhost -p 5432 -U pos -d postgres -c "CREATE DATABASE kapmeta;"

# Restore dump
psql -h localhost -p 5432 -U pos -d kapmeta -f db/backup/kapmeta_backup_sep14.sql
```

### Method 3: Using pgAdmin 4 or DBeaver
1. Connect to your PostgreSQL server (`localhost:5432`).
2. Create or select database `kapmeta`.
3. Open Query Tool and execute `db/backup/kapmeta_backup_sep14.sql`.
