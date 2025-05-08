CREATE TRIGGER trg_prevent_uuid_update
BEFORE UPDATE ON user_identities
FOR EACH ROW
EXECUTE FUNCTION prevent_uuid_update();