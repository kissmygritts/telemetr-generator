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
