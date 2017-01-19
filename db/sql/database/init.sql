-- create postgis extension
-- CREATE EXTENSION postgis;

-- create devices
CREATE TABLE devices (
  id serial PRIMARY KEY,
  serial_num character varying(50) UNIQUE,
  frequency real,
  vendor character varying(50),
  device_type character varying(50),
  mfg_date date,
  model character varying,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- create captures
CREATE TABLE captures (
  id serial PRIMARY KEY,
  perm_id varchar(20),
  cap_date date,
  sex varchar(8),
  age varchar(10),
  species varchar(4),
  notes varchar,
  serial_num varchar(50),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- create animals
CREATE TABLE animals (
  id serial PRIMARY KEY,
  perm_id varchar(20),
  sex varchar(8),
  age varchar(10),
  species varchar(4),
  notes varchar,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- create deployments
CREATE TABLE deployments (
  id serial PRIMARY KEY,
  animal_id integer REFERENCES animals(id),
  device_id integer REFERENCES devices(id),
  inservice date,
  outservice date,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now(),
  UNIQUE (animal_id, device_id)
);

-- create validity codes
CREATE TABLE validity_codes (
  code integer PRIMARY KEY,
  description varchar
);

-- seed validity codes with data
INSERT INTO validity_codes (code, description)
VALUES
  (1, 'valid position'),
  (2, 'position with no coordinates'),
  (3, 'position with low reliability'),
  (4, 'impossible spike'),
  (5, 'position outside study area'),
  (6, 'impossible biological location'),
  (7, 'duplicate timestamp');

-- create gps
CREATE TABLE gps (
  id serial PRIMARY KEY,
  serial_num varchar(50) REFERENCES devices(serial_num),
  acq_time_utc timestamp with time zone,
  acq_time_lcl timestamp with time zone,
  latitude numeric,
  longitude numeric,
  altitude numeric,
  easting numeric,
  northing numeric,
  activity numeric,
  temperature numeric,
  hdop numeric,
  pdop numeric,
  n_sats integer,
  fixtype varchar(10),
  gps_volts real,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- create relocations
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
  activity numeric,
  temperature numeric,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);
