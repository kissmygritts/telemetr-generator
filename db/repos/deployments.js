'use strict';
const sql = require('../sql').deployments;

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create)
  };
};
