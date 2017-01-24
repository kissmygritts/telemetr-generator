CREATE VIEW relocs_analysis AS
SELECT
  animals.perm_id,
  animals.species,
  animals.sex,
  devices.serial_num,
  relocations.acq_time_lcl AS acq_time,
  relocations.longitude,
  relocations.latitude,
  relocations.geom,
  relocations.validity_code
FROM (animals
  INNER JOIN relocations ON animals.id = relocations.animal_id)
  INNER JOIN devices ON relocations.device_id = devices.id
WHERE relocations.validity_code IN (1, 3)
ORDER BY animals.perm_id, relocations.acq_time_lcl;
