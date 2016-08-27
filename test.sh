#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"


function run_all_tests () {
  cd "$SELFPATH" || return $?
  local DIFF_CMD='diff'
  colordiff </dev/null &>/dev/null && DIFF_CMD[0]='colordiff'
  local TESTNAME= INPUT= SNIPPET= EXPECTED=

  TESTNAME='no data'
  INPUT=
  SNIPPET='cdir(rass);'
  EXPECTED="''"
  diffit || return $?

  TESTNAME='reading at startup'
  INPUT='hello\r\nworld!\n\n'
  SNIPPET='cdir(rass);'
  EXPECTED="'hello\r\nworld!\n\n'"
  diffit || return $?

  TESTNAME='strip BOM'
  INPUT='\xEF\xBB\xBF'"$INPUT"
  SNIPPET='cdir(rass.bind(null, { stripBOM: true }));'
  diffit || return $?

  TESTNAME='JSON w/o BOM'
  INPUT='{ "hello": "world" }'
  EXPECTED="{ hello: 'world' }"
  SNIPPET='cdir(rass.bind(null, JSON));'
  diffit || return $?

  TESTNAME='JSON with BOM'
  INPUT='\xEF\xBB\xBF'"$INPUT"
  EXPECTED="{ hello: 'world' }"
  SNIPPET='cdir(rass.bind(null, JSON));'
  diffit || return $?

  TESTNAME='reading late'
  SNIPPET="setTimeout(function () { $SNIPPET }, 10);"
  EXPECTED="Error: Don't use sync I/O after initialization!"
  diffit || return $?

  echo '+OK all tests passed'
  return 0
}


function diffit () {
  local SCRIPT='var rass = require("./read-all-stdin-sync.js");
    function cdir(doit) {
      try {
        console.dir(doit());
      } catch (err) {
        console.log(String(err));
      }
    }
    '"$SNIPPET"
  "${DIFF_CMD[@]}" -U 9002 \
    --label "expected @ $TESTNAME" <(echo "$EXPECTED") \
    --label 'actual' <(printf "$INPUT" | nodejs -e "$SCRIPT" 2>&1
    )
  return $?
}










run_all_tests "$@"; exit $?
