CREATE OR REPLACE FUNCTION prevent_corporation_id_update()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.corporation_id IS DISTINCT FROM OLD.corporation_id THEN
    RAISE EXCEPTION 'corporation_id is immutable and cannot be changed.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;