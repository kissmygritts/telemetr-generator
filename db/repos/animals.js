'use strict';
const sql = require('../sql').animals;

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create)
  };
};
