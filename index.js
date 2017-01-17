'use strict';

const express = require('express');
const db = require('./db').db;
const app = express();

// CREATE ROUTES:
// TODO: All of these routes should be POST rather than GET to better conform to HTTP standards
// tables
GET('/animals/create', () => db.animals.create());
GET('/captures/create', () => db.captures.create());
GET('/devices/create', () => db.devices.create());
GET('/deployments/create', () => db.deployments.create());
GET('/validity_codes/create', () => db.validityCodes.create());
GET('/validity_codes/init', () => db.validityCodes.init());
GET('/gps/create', () => db.gps.create());
GET('/relocations/create', () => db.relocations.create());

// triggers
GET('/triggers/parse_captures', () => db.triggers.parseCaptures());
GET('/triggers/updated_at', () => db.triggers.updatedAt());
GET('/triggers/gps_to_relocations', () => db.triggers.gpsToRelocations());
GET('/triggers/create_geom', () => db.triggers.createGeom());

// views
GET('/views/collar_deployments', () => db.views.collarDeployments());

// bootstrap the database creation, triggers/functions, and seed some data
GET('/telemetr/init', () => db.dbase.init());
GET('/telemetr/triggers', () => db.dbase.triggers());
GET('/telemetr/seed/animals', () => db.dbase.seed());
GET('/telemetr/seed/gps', () => db.dbase.gps());

function GET(url, handler) {
  app.get(url, (req, res) => {
    handler(req)
    .then(data => res.status(200).json({ success: true, data: data }))
    .catch(err => res.status(400).json({ success: false, error: err.message || err }));
  });
}

app.listen(3000, () => {
  console.log('listening on localhost:3000');
});
