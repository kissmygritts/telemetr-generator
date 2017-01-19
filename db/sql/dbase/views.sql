-- collar deployments with perm_id and device serial number
CREATE VIEW collar_deployments AS
SELECT
  animals.perm_id,
  devices.serial_num,
  deployments.inservice,
  deployments.outservice,
  deployments.animal_id,
  deployments.device_id,
  deployments.id AS deployment_id
FROM (deployments
  INNER JOIN animals ON deployments.animal_id = animals.id)
  INNER JOIN devices ON deployments.device_id = devices.id
ORDER BY animals.perm_id, deployments.id DESC;

-- select portion of the INSERT query to transfer gps data
-- to the relocations table
CREATE VIEW gps_deployment AS
SELECT
  gps.id AS gps_id,
  deployments.device_id,
  deployments.animal_id,
  gps.acq_time_utc,
  gps.acq_time_lcl,
  gps.longitude,
  gps.latitude,
  gps.altitude,
  gps.activity,
  gps.temperature
FROM deployments, devices, gps
WHERE
  gps.serial_num = devices.serial_num AND
  devices.id = deployments.device_id AND
  (
    (gps.acq_time_lcl >= deployments.inservice AND
     gps.acq_time_lcl <= deployments.outservice)
     OR
    (gps.acq_time_lcl >= deployments.inservice AND
     deployments.outservice IS NULL)
  );

-- count of the number of relocations for each animal
CREATE VIEW relocations_count AS
SELECT
  animals.perm_id,
  count(relocations.animal_id) AS relocations,
  count(relocations.geom) AS valid_relocations
FROM animals
  INNER JOIN relocations ON animals.id = relocations.animal_id
GROUP BY animals.perm_id
ORDER BY animals.perm_id;

-- step distance, speed and angle
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

-- count of relocations grouped by validity code
CREATE VIEW relocations_validity_count AS
SELECT
  validity_codes.code,
  validity_codes.description,
  count(validity_codes.code) AS n
FROM relocations
  INNER JOIN validity_codes ON relocations.validity_code = validity_codes.code
GROUP BY validity_codes.code
ORDER BY validity_codes.code;
