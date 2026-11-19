-- Migration: Add auto_resume_at column to item_availability table
-- Date: 2026-10-16
-- Purpose: Support timed item 86/off with automatic re-enable (1hr, 2hr, 6hr, next day)

ALTER TABLE item_availability ADD COLUMN IF NOT EXISTS auto_resume_at timestamptz NULL;
CREATE INDEX IF NOT EXISTS idx_item_availability_auto_resume ON item_availability(auto_resume_at) WHERE auto_resume_at IS NOT NULL;

INSERT INTO schema_migrations (version) VALUES ('0045_add_auto_resume_at_to_item_availability.sql') ON CONFLICT DO NOTHING;
