-- function to update the updated_at field to now()
CREATE OR REPLACE FUNCTION updated_at()
RETURNS trigger AS
$BODY$
BEGIN
IF NEW IS DISTINCT FROM OLD THEN
  NEW.updated_at = now();
END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- applying trigger to all the tables that need it
CREATE TRIGGER update_timestamp
  BEFORE UPDATE
  ON captures
  FOR EACH ROW
  EXECUTE PROCEDURE updated_at();

CREATE TRIGGER update_timestamp
  BEFORE UPDATE
  ON animals
  FOR EACH ROW
  EXECUTE PROCEDURE updated_at();

CREATE TRIGGER update_timestamp
  BEFORE UPDATE
  ON devices
  FOR EACH ROW
  EXECUTE PROCEDURE updated_at();

CREATE TRIGGER update_timestamp
  BEFORE UPDATE
  ON deployments
  FOR EACH ROW
  EXECUTE PROCEDURE updated_at();

CREATE TRIGGER update_timestamp
  BEFORE UPDATE
  ON gps
  FOR EACH ROW
  EXECUTE PROCEDURE updated_at();

CREATE TRIGGER update_timestamp
  BEFORE UPDATE
  ON relocations
  FOR EACH ROW
  EXECUTE PROCEDURE updated_at();
