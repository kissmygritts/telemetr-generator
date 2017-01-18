CREATE OR REPLACE FUNCTION impossible_relocations()
RETURNS bigint AS $$

WITH rows AS (
  UPDATE
    relocations
  SET
    validity_code = 4
  WHERE
    id IN (
      SELECT id
      FROM
        (SELECT
          id,
          ST_DistanceSpheroid(
            geom,
            LAG(geom, 1)
            OVER (
              PARTITION BY animal_id
              ORDER BY acq_time_lcl),
              'SPHEROID["WGS 84",6378137,298.257223563]') /
            (EXTRACT(epoch FROM acq_time_lcl) -
             EXTRACT(epoch FROM (
                LAG(acq_time_lcl, 1)
                OVER (
                  PARTITION BY animal_id
                  ORDER BY acq_time_lcl)))) * 3600 AS speed_from,
          ST_DistanceSpheroid(
            geom,
            LEAD(geom, 1)
            OVER (
              PARTITION BY animal_id
              ORDER BY acq_time_lcl),
              'SPHEROID["WGS 84",6378137,298.257223563]') /
            (- EXTRACT(epoch FROM acq_time_lcl) +
             EXTRACT(epoch FROM (
                LEAD(acq_time_lcl, 1)
                OVER (
                  PARTITION BY animal_id
                  ORDER BY acq_time_lcl)))) * 3600 AS speed_to,
          cos(
            ST_Azimuth((LAG(geom, 1)
              OVER (
                PARTITION BY animal_id
                ORDER BY acq_time_lcl))::geography,
                geom::geography) -
            ST_Azimuth(
              geom::geography,
              (LEAD(geom, 1)
              OVER (
                PARTITION BY animal_id
                ORDER BY acq_time_lcl))::geography)) AS rel_angle
        FROM relocations
        WHERE validity_code = 1) t
      WHERE
        rel_angle < -.99 AND
        speed_from > 2500 AND
        speed_to > 2500)
      RETURNING 1
  )
SELECT count(*) FROM rows;

$$ LANGUAGE sql;  
