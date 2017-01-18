COPY gps (
  serial_num,
  acq_time_lcl,
  longitude,
  latitude,
  altitude,
  hdop,
  temperature,
  fixtype,
  gps_volts
)
FROM '/Users/mitchellgritts/Documents/telemetr/telemetr-db/data/collars_gsm.csv'
WITH (FORMAT csv, DELIMITER ',', HEADER true);

-- change the FROM clause to point to your path: FROM '/path/to/telemetr-generator/data/collars_gsm.csv'
