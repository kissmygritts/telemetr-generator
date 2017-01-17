`use strict`;
const sql = require('../sql').gps

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create)
  };
};
