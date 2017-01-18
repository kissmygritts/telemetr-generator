CREATE VIEW relocation_steps AS
SELECT
  animal_id AS id,
  acq_time_lcl,
  LEAD(acq_time_lcl,-1)
    OVER (
      PARTITION BY animal_id
      ORDER BY acq_time_lcl) AS acq_time_1,
  (EXTRACT(epoch FROM acq_time_lcl) -
  LEAD(EXTRACT(epoch FROM acq_time_lcl), -1)
    OVER (
      PARTITION BY animal_id
      ORDER BY acq_time_lcl))::integer AS deltat,
  (ST_DistanceSpheroid(
    geom,
    LEAD(geom, -1)
      OVER (
        PARTITION BY animal_id
        ORDER BY acq_time_lcl),
    'SPHEROID["WGS 84",6378137,298.257223563]'))::integer AS dist,
  (ST_DistanceSpheroid(
    geom,
    LEAD(geom, -1)
      OVER (
        PARTITION BY animal_id
        ORDER BY acq_time_lcl),
    'SPHEROID["WGS 84",6378137,298.257223563]')/
  ((EXTRACT(epoch FROM acq_time_lcl) -
  LEAD(
    EXTRACT(epoch FROM acq_time_lcl), -1)
    OVER (
      PARTITION BY animal_id
      ORDER BY acq_time_lcl))+1) * 60 * 60)::numeric(8,2) AS speed
FROM relocations
WHERE validity_code = 1
LIMIT 10;
