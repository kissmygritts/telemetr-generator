'use strict';
const sql = require('../sql').captures;

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create)
  };
};
