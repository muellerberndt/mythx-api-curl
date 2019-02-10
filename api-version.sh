#!/bin/bash

HELP="usage: $0
  Gets current versions of Mythril API and its sub-modules.
"

cd $(dirname ${BASH_SOURCE[0]})

MYTHX_LOGIN=false
. ./common.sh

cmd="curl -v GET ${MYTHX_API_URL}/v1/version"
echo "Running: $cmd"
$cmd  >$stdout 2>$stderr
rc=$?

process_outputs $rc 1
exit $rc
