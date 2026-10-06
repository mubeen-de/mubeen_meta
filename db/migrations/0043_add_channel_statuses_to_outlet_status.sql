-- Migration: Add channel operation statuses (dine-in, delivery, takeaway) to outlet_status
-- Date: 2026-10-03

ALTER TABLE outlet_status
  ADD COLUMN IF NOT EXISTS dine_in_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS delivery_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS takeaway_active BOOLEAN NOT NULL DEFAULT true;

INSERT INTO schema_migrations (version) VALUES ('0043_add_channel_statuses_to_outlet_status') ON CONFLICT DO NOTHING;
