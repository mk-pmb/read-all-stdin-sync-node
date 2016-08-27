/*jslint indent: 2, maxlen: 80, node: true */
/* -*- tab-width: 2 -*- */
'use strict';

var fs = require('fs');

function ifset(val, dflt) { return (val === undefined ? dflt : val); }

function readAllStdinSync(opts) { return readAllStdinSync.doit(opts); }

readAllStdinSync.doit = function (opts) {
  var evilBlockingRead = 'readFileSync';
  evilBlockingRead = fs[evilBlockingRead].bind(fs);
  // ^- How to show jslint that you know you really shouldn't do it,
  //    but are really desperate to save that one level of indentation
  //    that an async callback would cost you.
  switch (opts && typeof opts) {
  case 'string':
  case null:
    opts = { encoding: opts };
    break;
  case 'object':
    break;
  default:
    opts = false;
    break;
  }
  return evilBlockingRead(process.stdin.fd, ifset(opts.encoding, 'utf-8'));
};


function tooLate() { throw new Error(tooLate.dont); }
tooLate.dont = "Don't use sync I/O after initialization!";
tooLate.killIt = function () { readAllStdinSync.doit = tooLate; };
setImmediate(tooLate.killIt);


module.exports = readAllStdinSync;
