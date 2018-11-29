#!/bin/bash
 # Get issues from a finished analysis

HELP="usage: $0 UUID
  Get issues from a finished /analysis POST
"
cd $(dirname ${BASH_SOURCE[0]})

. ./common.sh

if (( $# == 1 )) ; then
    UUID=$1
fi

if [[ -z $UUID ]] ; then
    echo >&2 "You need to either pass a UUID of a previous submitted analysis"
    exit 1
fi

prefix="GET ${MYTHRIL_API_URL}/v1/analyses/${UUID}/issues"
echo "Issuing HTTP $prefix
  (with MYTHRIL_ACCESS_TOKEN)
"
curl -X $prefix \
  -H "Authorization: Bearer $MYTHRIL_ACCESS_TOKEN"  >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
