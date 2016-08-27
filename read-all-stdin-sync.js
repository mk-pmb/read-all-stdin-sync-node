/*jslint indent: 2, maxlen: 80, node: true */
/* -*- tab-width: 2 -*- */
'use strict';

var fs = require('fs');

function readAllStdinSync(opts) { return readAllStdinSync.doit(opts); }

readAllStdinSync.doit = function (opts) {
  var evilBlockingRead = 'readFileSync', data;
  evilBlockingRead = fs[evilBlockingRead].bind(fs);
  // ^- How to show jslint that you know you really shouldn't do it,
  //    but are really desperate to save that one level of indentation
  //    that an async callback would cost you.
  opts = parseOpts(opts);
  if (opts.encoding === undefined) { opts.encoding = 'utf-8'; }
  data = evilBlockingRead(process.stdin.fd, opts.encoding);
  if (data && opts.stripBOM) {
    if (Buffer.isBuffer(data)) {
      if (data[0] === 0xEF && data[1] === 0xBB && data[2] === 0xBF) {
        data = data.slice(3);
      }
    } else {
      if (data[0] === '\uFEFF') { data = data.slice(1); }
      if (opts.stripBOM === JSON) { data = JSON.parse(data); }
    }
  }
  return data;
};


function parseOpts(opts) {
  switch (opts) {
  case null:
  case 'binary':
  case 'buffer':
  case Buffer:
    return { encoding: null };
  case JSON:
  case 'JSON':
  case 'json':
    return { stripBOM: JSON };
  }
  switch (opts && typeof opts) {
  case 'string':
    return { encoding: opts };
  case 'object':
    return Object.assign({}, opts);
  }
  return {};
}


function tooLate() { throw new Error(tooLate.dont); }
tooLate.dont = "Don't use sync I/O after initialization!";
tooLate.killIt = function () { readAllStdinSync.doit = tooLate; };
setImmediate(tooLate.killIt);


module.exports = readAllStdinSync;
