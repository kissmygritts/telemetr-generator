'use strict';
const sql = require('../sql').dbase

module.exports = (rep, pgp) => {
  return {
    init: () => rep.none(sql.init),
    triggers: () => rep.none(sql.triggers),
    views: () => rep.none(sql.views),
    seed: () => rep.none(sql.seed),
    gps: () => rep.none(sql.gps)
  };
};
