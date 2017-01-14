'use strict';
const sql = require('../sql').devices;

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create)
  };
};
