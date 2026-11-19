-- Migration 0046: Table Reservations for Floor Host and Management
CREATE TABLE IF NOT EXISTS table_reservations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    outlet_id UUID NOT NULL,
    dining_table_id TEXT NOT NULL,
    customer_name TEXT NOT NULL,
    customer_phone TEXT,
    guest_count INT NOT NULL DEFAULT 2,
    reservation_time TIMESTAMPTZ NOT NULL DEFAULT now(),
    status TEXT NOT NULL DEFAULT 'CONFIRMED',
    special_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_table_reservations_outlet ON table_reservations(outlet_id);
CREATE INDEX IF NOT EXISTS idx_table_reservations_table ON table_reservations(dining_table_id);
CREATE INDEX IF NOT EXISTS idx_table_reservations_time ON table_reservations(reservation_time);
