'use strict';
const sql = require('../sql').views

module.exports = (rep, pgp) => {
  return {
    collarDeployments: () => rep.none(sql.collarDeployments)
  }
}
