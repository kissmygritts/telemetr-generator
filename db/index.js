'use strict'

const promise = require('bluebird')
const env = process.env.NODE_ENV
const config = require('../config/database.json')[env]
const repos = {
  animals: require('./repos/animals'),
  captures: require('./repos/captures'),
  devices: require('./repos/devices'),
  deployments: require('./repos/deployments'),
  validityCodes: require('./repos/validityCodes'),
  gps: require('./repos/gps'),
  relocations: require('./repos/relocations'),
  triggers: require('./repos/triggers'),
  views: require('./repos/views'),
  dbase: require('./repos/dbase')
}

// TODO: change this to be a loop
const options = {
  promiseLib: promise,
  extend: obj => {
    obj.animals = repos.animals(obj, pgp);
    obj.captures = repos.captures(obj,pgp);
    obj.devices = repos.devices(obj, pgp);
    obj.deployments = repos.deployments(obj, pgp);
    obj.validityCodes = repos.validityCodes(obj, pgp);
    obj.gps = repos.gps(obj, pgp);
    obj.relocations = repos.relocations(obj, pgp);
    obj.triggers = repos.triggers(obj, pgp);
    obj.views = repos.views(obj, pgp);
    obj.dbase = repos.dbase(obj, pgp);
  }
}

const pgp = require('pg-promise')(options)
const db = pgp(config)
const diag = require('./diagnostics')
diag.init(options)

module.exports = { pgp, db }
