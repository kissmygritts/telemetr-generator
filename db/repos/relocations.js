`use strict`;
const sql = require('../sql').relocations

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create)
  };
};
