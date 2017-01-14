'use strict';

const os = require('os');
const fs = require('fs');
const monitor = require('pg-monitor');

monitor.setTheme('matrix');

const $DEV = process.env.NODE_ENV === 'development';

const logFile = './db/errors.log';

monitor.log = (msg, info) => {
  if (info.event === 'error') {
    let logText = os.EOL + msg;

    if (info.time) {
      logText = os.EOL + logText;
    }

    fs.appendFileSync(logFile, logText);
  }

  if (!$DEV) {
    info.display = false;
  }
};

let attached = false;

module.exports = {
  init: options => {
    if (attached) {
      return;
    }
    attached = true;

    if ($DEV) {
      monitor.attach(options);
    } else {
      monitor.attach(options, ['error']);
    }
  },
  done: () => {
    if (attached) {
      attached = false;
      monitor.detach();
    }
  }
};
