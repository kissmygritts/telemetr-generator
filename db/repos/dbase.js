'use strict';
const sql = require('../sql').dbase

module.exports = (rep, pgp) => {
  return {
    init: () => rep.none(sql.init),
    triggers: () => rep.none(sql.triggers)
  };
};
