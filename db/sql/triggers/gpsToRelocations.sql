-- function that will insert records into RELOCATIONS as long as
-- locations fall between the deployment dates for that animal.
-- TODO: include in WHERE clause a check that current row isn't already in RELOCATIONS
CREATE OR REPLACE FUNCTION gps_to_relocations()
RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO relocations (
    gps_id,
    device_id,
    animal_id,
    acq_time_utc,
    acq_time_lcl,
    longitude,
    latitude,
    altitude
  )
  SELECT
    NEW.id AS gps_id,
    deployments.device_id,
    deployments.animal_id,
    NEW.acq_time_utc,
    NEW.acq_time_lcl,
    NEW.longitude,
    NEW.latitude,
    NEW.altitude
  FROM deployments, devices
  WHERE
    NEW.serial_num = devices.serial_num AND
    devices.id = deployments.device_id AND
    (
      (NEW.acq_time_lcl >= deployments.inservice AND
       NEW.acq_time_lcl <= deployments.outservice)
       OR
      (NEW.acq_time_lcl >= deployments.inservice AND
       deployments.outservice IS NULL)
    );
  RETURN NULL;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- apply function to GPS table
CREATE TRIGGER gps_to_relocations
  AFTER INSERT
  ON gps
  FOR EACH ROW
  EXECUTE PROCEDURE gps_to_relocations();
