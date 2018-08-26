#!/bin/bash
# Get the state of a prior run

cd $(dirname ${BASH_SOURCE[0]})

. ./common.sh

if (( $# == 1 )) ; then
    UUID=$1
fi

if [[ -z $UUID ]] ; then
    echo >&2 "You need to either pass a UUID of a previous submitted analysis"
    exit 1
fi

prefix="GET https://api.mythril.ai/mythril/v1/analysis/$UUID"
echo "Issuing HTTP $prefix
  (with MYTHRIL_API_KEY)"

curl -i -X $prefix \
  -H "Authorization: Bearer $MYTHRIL_API_KEY"  >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
