`use strict`;
const sql = require('../sql').validty_codes

module.exports = (rep, pgp) => {
  return {
    create: () => rep.none(sql.create),
    init: () => rep.many(sql.init);
  };
};
