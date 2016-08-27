#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"


function run_all_tests () {
  cd "$SELFPATH" || return $?
  local DIFF_CMD='diff'
  colordiff </dev/null &>/dev/null && DIFF_CMD[0]='colordiff'
  local TESTNAME= INPUT= SNIPPET= EXPECTED=

  TESTNAME='reading at startup'
  INPUT='hello\r\nworld!\n\n'
  EXPECTED="'hello\r\nworld!\n\n'"
  SNIPPET='cdir(rass);'
  diffit || return $?

  TESTNAME='no data'
  INPUT=
  EXPECTED="''"
  SNIPPET='cdir(rass);'
  diffit || return $?

  TESTNAME='reading late'
  EXPECTED="Error: Don't use sync I/O after initialization!"
  SNIPPET="setTimeout(function () { $SNIPPET }, 10);"
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
