'use strict';

const QueryFile = require('pg-promise').QueryFile;
const path = require('path');

function sql(file) {
  const fullPath = path.join(__dirname, file);
  const options = { minify: true };
  return new QueryFile(fullPath, options);
}

module.exports = {
  animals: {
    create: sql('animals/create.sql')
  },
  captures: {
    create: sql('captures/create.sql')
  },
  devices: {
    create: sql('devices/create.sql')
  }
};
