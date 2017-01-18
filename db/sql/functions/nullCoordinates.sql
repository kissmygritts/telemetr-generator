CREATE OR REPLACE FUNCTION null_relocations()
RETURNS bigint AS $$

WITH rows AS (
  UPDATE relocations
  SET
    validity_code = 2
  WHERE geom IS NULL AND
    validity_code = 1
  RETURNING 1
  )
SELECT count(*) FROM rows;

$$ LANGUAGE sql;
