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
