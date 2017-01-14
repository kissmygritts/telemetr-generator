'use strict';

const express = require('express');
const db = require('./db').db;
const app = express();

GET('/animals/create', () => db.animals.create());
GET('/captures/create', () => db.captures.create());
GET('/devices/create', () => db.devices.create());

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
