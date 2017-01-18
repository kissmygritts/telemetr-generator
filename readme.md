## telemetr-generator
v0.1.0

This repo is for generating the telemetr database schema (tables, views, functions, and triggers, etc.). This is a temporary solution. It was quick for me to create. Future development of a legitimate migration solution is pending.

The database structure in this repo is required for telemetr-api to work.

## Database initialization

1. install Node.js
1. download and install PostgreSQL, then PostGIS
2. create database `createdb telemetr`
3. connect to the database `psql telemetr`
4. create the PostGIS extension `CREATE EXTENSION postgis;`
5. download and install
```
mkdir telemetr
cd telemetr

git clone https://github.com/kissmygritts/telemetr-generator.git
npm install
```
## change `config`

The database connection object is in `./db/index.js`. Change the data to match your database credentials. These can be for localhost, or for a remote server.

## Bootstrapping database

Visit each of the following URLs to generate the database. If you have your own data don't seed the database.

1. generate DB schema: `localhost:3000/telemetr/init`
2. generate triggers: `localhost:3000/telemetr/triggers`
3. seed device and animal data: `localhost:3000/telemetr/seed/animals`
4. seed gps data: `localhost:3000/telemetr/seed/gps`
