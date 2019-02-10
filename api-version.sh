#!/bin/bash

HELP="usage: $0
  Gets current versions of Mythril API and its sub-modules.
"

cd $(dirname ${BASH_SOURCE[0]})

MYTHX_LOGIN=false
. ./common.sh

prefix="GET ${MYTHX_API_URL}/v1/version"

set -x
curl -v $prefix >$stdout 2>$stderr
rc=$?
set +x

process_outputs $rc 1
exit $rc
