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

curl -X GET \
  https://api.mythril.ai/v1/analyses/${UUID}/issues \
  -H "Authorization: Bearer $MYTHRIL_API_KEY"  >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
