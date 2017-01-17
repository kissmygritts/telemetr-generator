'use strict';

const promise = require('bluebird');
const repos = {
  animals: require('./repos/animals'),
  captures: require('./repos/captures'),
  devices: require('./repos/devices'),
  deployments: require('./repos/devices')
};

const options = {
  promiseLib: promise,
  extend: obj => {
    obj.animals = repos.animals(obj, pgp);
    obj.captures = repos.captures(obj,pgp);
    obj.devices = repos.devices(obj, pgp);
    obj.deployments = repos.deployments(obj, pgp);
    obj.validity_codes = repos.validity_codes(obj, pgp);
    obj.gps = repos.gps(obj, pgp);
    obj.relocations = repos.gps(obj, pgp);
  }
};

// database config, pull this out as connection string
const config = {
  host: 'localhost',
  port: 5432,
  database: 'telemetr_gen_test'
};

const pgp = require('pg-promise')(options);
const db = pgp(config);
const diag = require('./diagnostics');
diag.init(options);

module.exports = { pgp, db };
