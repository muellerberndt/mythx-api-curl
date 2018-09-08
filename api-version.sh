#!/bin/bash
# Get the state of a prior run

cd $(dirname ${BASH_SOURCE[0]})

. ./common.sh

prefix="GET https://api.mythril.ai/v1/version"
echo "Issuing HTTP $prefix"

curl -i -X $prefix >$stdout 2>$stderr
rc=$?
process_outputs $rc 1
exit $rc
