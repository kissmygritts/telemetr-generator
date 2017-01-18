'use strict';
const sql = require('../sql').views

module.exports = (rep, pgp) => {
  return {
    collarDeployments: () => rep.none(sql.collarDeployments),
    gpsDeployments: () => rep.none(sql.gpsDeployments),
    relocationSteps: () => rep.none(sql.relocationSteps),
    relocationsValidityCount: () => rep.none(sql.relocationsValidityCount),
    relocationsCount: () => rep.none(sql.relocationsCount)
  }
}
