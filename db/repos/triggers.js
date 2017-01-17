'use strict';
const sql = require('../sql').triggers

module.exports = (rep, pgp) => {
  return {
    parseCaptures: () => rep.none(sql.parseCaptures)
  }
}
