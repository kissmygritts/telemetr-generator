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
