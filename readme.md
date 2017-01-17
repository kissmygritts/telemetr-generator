## telemetr-generator
v0.0.1

This repo is for generating the telemetr database schema (tables, views, functions, and triggers).

## Database initialization

1. download and install PostgreSQL, then PostGIS
2. create database `createdb telemetr`
3. connect to the database `psql telemetr`
4. create the PostGIS extension `CREATE EXTENSION postgis;`

## Bootstrapping the database

```
mkdir telemetr
cd telemetr

git clone https://github.com/kissmygritts/telemetr-generator.git
npm install
```
