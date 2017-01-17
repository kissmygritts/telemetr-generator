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

-- function to create the GEOM field from longitude and latitude
-- only applied to RELOCATIONS, not GPS
CREATE OR REPLACE FUNCTION create_geom()
RETURNS trigger AS
$BODY$
DECLARE
thegeom geometry;
BEGIN

IF NEW.longitude IS NOT NULL AND NEW.latitude IS NOT NULL THEN
thegeom = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
NEW.geom = thegeom;
END IF;

RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- create trigger on RELOCATIONS
CREATE TRIGGER add_geom
BEFORE INSERT
ON relocations
FOR EACH ROW
EXECUTE PROCEDURE create_geom();
