-- ------------------------------------------------------------------------------
-- File: create_corporation_id_protection_triggers.sql
-- Description:
--   This script creates a trigger function and automatically adds triggers
--   to all tables in the 'public' schema that contain a column named `corporation_id`.
--
-- Purpose:
--   To enforce immutability of the `corporation_id` column across all relevant tables.
--   This prevents accidental or unauthorized updates to the `corporation_id`, which is
--   a critical field for multi-tenant data isolation in a SaaS architecture.
--
-- What it does:
--   1. Defines a trigger function `prevent_corporation_id_update()` which raises an error
--      if any update tries to change the `corporation_id` value.
--   2. Iterates over all tables in the `public` schema that contain a `corporation_id`.
--   3. Creates a BEFORE UPDATE trigger for each matching table, attaching the enforcement function.
--
-- Notes:
--   - Existing triggers named `trg_prevent_corporation_id_update_*` will be dropped and recreated.
--   - Safe to rerun (idempotent).
--   - Does not depend on foreign key constraints or specific table names.
-- ------------------------------------------------------------------------------

-- Step 1: Create the trigger function (shared by all tables)
CREATE OR REPLACE FUNCTION prevent_corporation_id_update()
RETURNS trigger AS $$
BEGIN
  IF NEW.corporation_id IS DISTINCT FROM OLD.corporation_id THEN
    RAISE EXCEPTION 'corporation_id cannot be changed.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Apply the trigger to all relevant tables dynamically
DO $$
DECLARE
  tbl RECORD;
BEGIN
  FOR tbl IN
    SELECT table_name
    FROM information_schema.columns
    WHERE column_name = 'corporation_id'
      AND table_schema = 'public'
  LOOP
    EXECUTE format(
      'DROP TRIGGER IF EXISTS trg_prevent_corporation_id_update_%I ON %I;',
      tbl.table_name, tbl.table_name
    );

    EXECUTE format(
      'CREATE TRIGGER trg_prevent_corporation_id_update_%I
       BEFORE UPDATE ON %I
       FOR EACH ROW
       WHEN (OLD.corporation_id IS NOT NULL)
       EXECUTE FUNCTION prevent_corporation_id_update();',
      tbl.table_name, tbl.table_name
    );
  END LOOP;
END;
$$;