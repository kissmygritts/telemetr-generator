-- the following statements are in the proper order to conform to the data flow of the database
-- seed devices
INSERT INTO devices (
serial_num,
vendor,
device_type,
mfg_date,
frequency
)
VALUES
  ('GSM01438', 'vectronic', 'gps', '2005-01-01' ,151.33),
  ('GSM01508', 'vectronic', 'gps', '2005-01-01', 151.01),
  ('GSM01511', 'vectronic', 'gps', '2005-01-01', 151.07),
  ('GSM01512', 'vectronic', 'gps', '2005-01-01', 151.089),
  ('GSM02927', 'vectronic', 'gps', '2005-01-01', 151.145);

-- seed captures, this will trigger a function to parse the capture data
-- into the proper tables (animals, deployments)
INSERT INTO captures (
  perm_id,
  cap_date,
  sex,
  age,
  species,
  serial_num
)
VALUES
  ('F09', '2005-10-16', 'female', 'adult', 'ROED', 'GSM01512'),
  ('M06', '2005-10-23', 'male', 'adult', 'ROED', 'GSM01508'),
  ('F10', '2005-10-21', 'female', 'adult', 'ROED', 'GSM01511'),
  ('M10', '2006-11-12', 'male', 'adult', 'ROED', 'GSM02927'),
  ('M03', '2005-03-20', 'male', 'adult', 'ROED', 'GSM01438');

-- insert outservice dates for the collars
UPDATE deployments t
SET outservice = '2006-05-27'
FROM devices
WHERE t.device_id = devices.id AND devices.serial_num = 'GSM01438';

UPDATE deployments t
SET outservice = '2006-10-28'
FROM devices
WHERE t.device_id = devices.id AND devices.serial_num = 'GSM01508';

UPDATE deployments t
SET outservice = '2007-02-09'
FROM devices
WHERE t.device_id = devices.id AND devices.serial_num = 'GSM01511';

UPDATE deployments t
SET outservice = '2006-10-29'
FROM devices
WHERE t.device_id = devices.id AND devices.serial_num = 'GSM01512';

UPDATE deployments t
SET outservice = '2008-03-15'
FROM devices
WHERE t.device_id = devices.id AND devices.serial_num = 'GSM02927';
