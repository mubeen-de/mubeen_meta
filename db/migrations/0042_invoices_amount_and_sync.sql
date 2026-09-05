-- Sync invoice columns between Prisma model and raw SQL schema
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS amount BIGINT DEFAULT 0;
ALTER TABLE invoices ADD COLUMN IF NOT EXISTS tax_amount BIGINT DEFAULT 0;
ALTER TABLE invoices ALTER COLUMN invoice_number DROP NOT NULL;

CREATE OR REPLACE FUNCTION sync_invoice_fields()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.invoice_number IS NULL AND NEW.invoice_no IS NOT NULL THEN
    NEW.invoice_number := NEW.invoice_no;
  ELSIF NEW.invoice_no IS NULL AND NEW.invoice_number IS NOT NULL THEN
    NEW.invoice_no := NEW.invoice_number;
  END IF;

  IF (NEW.amount IS NOT NULL AND NEW.amount > 0) AND (NEW.amount_minor IS NULL OR NEW.amount_minor = 0) THEN
    NEW.amount_minor := NEW.amount;
  ELSIF (NEW.amount_minor IS NOT NULL AND NEW.amount_minor > 0) AND (NEW.amount IS NULL OR NEW.amount = 0) THEN
    NEW.amount := NEW.amount_minor;
  END IF;

  IF (NEW.tax_amount IS NOT NULL AND NEW.tax_amount > 0) AND (NEW.tax_amount_minor IS NULL OR NEW.tax_amount_minor = 0) THEN
    NEW.tax_amount_minor := NEW.tax_amount;
  ELSIF (NEW.tax_amount_minor IS NOT NULL AND NEW.tax_amount_minor > 0) AND (NEW.tax_amount IS NULL OR NEW.tax_amount = 0) THEN
    NEW.tax_amount := NEW.tax_amount_minor;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_invoice_fields ON invoices;
CREATE TRIGGER trg_sync_invoice_fields
BEFORE INSERT OR UPDATE ON invoices
FOR EACH ROW
EXECUTE FUNCTION sync_invoice_fields();
