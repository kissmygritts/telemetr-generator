-- function, parses new records into capture table into animals and devices table
CREATE OR REPLACE FUNCTION parse_captures()
RETURNS trigger AS
$BODY$
BEGIN
  -- insert new capture into animal
  INSERT INTO animals (
    perm_id,
    sex,
    age,
    species,
    notes
  )
  SELECT
    NEW.perm_id,
    NEW.sex,
    NEW.age,
    NEW.species,
    NEW.notes
  FROM captures
  WHERE perm_id = NEW.perm_id;

  -- insert new deployment
  INSERT INTO deployments (
    animal_id,
    device_id,
    inservice
  )
  SELECT
    animals.id AS animal_id,
    devices.id AS device_id,
    captures.cap_date AS inservice
  FROM (captures
    INNER JOIN animals ON captures.perm_id = animals.perm_id)
    INNER JOIN devices ON captures.serial_num = devices.serial_num
  WHERE captures.perm_id = NEW.perm_id;

  RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- trigger, apply function to captures table
CREATE TRIGGER captures_to_deployments
  AFTER INSERT
  ON captures
  FOR EACH ROW
  EXECUTE PROCEDURE parse_captures();
