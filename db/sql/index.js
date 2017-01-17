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
  },
  deployments: {
    create: sql('deployments/create.sql')
  },
  validityCodes: {
    create: sql('validityCodes/create.sql'),
    init: sql('validityCodes/init.sql')
  },
  gps: {
    create: sql('gps/create.sql')
  },
  relocations: {
    create: sql('relocations/create.sql')
  },
  triggers: {
    parseCaptures: sql('triggers/parseCapture.sql'),
    updatedAt: sql('triggers/updatedAt.sql'),
    gpsToRelocations: sql('triggers/gpsToRelocations.sql'),
    createGeom: sql('triggers/createGeom.sql')
  },
  views: {
    collarDeployments: sql('views/collarDeployments.sql')
  },
  dbase: {
    init: sql('dbase/init.sql'),
    triggers: sql('dbase/triggers.sql')
  }
};
