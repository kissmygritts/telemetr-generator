'use strict';

const express = require('express');
const db = require('./db').db;
const app = express();

app.listen(3000, () => {
  console.log('listening on localhost:3000');
});
