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
