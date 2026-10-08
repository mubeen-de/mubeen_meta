-- 0044_add_captain_code_to_users.sql
-- Adds captain_code column to users table so that Captains (Waiters)
-- have a persistent, dedicated station badge (e.g. cp1, cp2, cp3, cp4)
-- that follows their account across all physical tablets/devices.

-- +migrate Up
ALTER TABLE users ADD COLUMN IF NOT EXISTS captain_code TEXT;

COMMENT ON COLUMN users.captain_code IS 'Permanent operational captain code (e.g. cp1, cp2, cp3, cp4) assigned to waiter/captain staff.';

-- +migrate Down
ALTER TABLE users DROP COLUMN IF EXISTS captain_code;
