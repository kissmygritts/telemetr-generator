CREATE TABLE relocations (
  id serial PRIMARY KEY,
  gps_id integer REFERENCES gps(id),
  animal_id integer REFERENCES animals(id),
  device_id integer REFERENCES devices(id),
  acq_time_utc timestamp with time zone,
  acq_time_lcl timestamp with time zone,
  latitude numeric,
  longitude numeric,
  geom geometry(Point, 4326),
  altitude numeric,
  validity_code integer REFERENCES validity_codes(code) DEFAULT 1,
  easting numeric,
  norhting numeric,
  utm_srid integer,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);
