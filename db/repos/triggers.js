'use strict';
const sql = require('../sql').triggers

module.exports = (rep, pgp) => {
  return {
    parseCaptures: () => rep.none(sql.parseCaptures),
    updatedAt: () => rep.none(sql.updatedAt),
    gpsToRelocations: () => rep.none(sql.gpsToRelocations),
    createGeom: () => rep.none(sql.createGeom)
  }
}
