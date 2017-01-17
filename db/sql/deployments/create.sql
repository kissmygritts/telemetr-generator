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
