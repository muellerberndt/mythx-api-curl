#!/bin/bash
# Get the status of a prior run

HELP="usage: $0 UUID
  Get the status of a prior '/analyses' POST
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

prefix="GET ${MYTHRIL_API_URL}/v1/analyses/$UUID"
if [[ -n $MYTHRIL_ACCESS_TOKEN ]] ; then
    echo "Issuing HTTP $prefix
  (with MYTHRIL_ACCESS_TOKEN)"

    curl -i -X $prefix \
	 -H "Authorization: Bearer $MYTHRIL_ACESS_TOKEN"  >$stdout 2>$stderr
else
    echo "Issuing HTTP $prefix
  (with MYTHRIL_API_KEY)"

    curl -i -X $prefix \
	 -H "Authorization: Bearer $MYTHRIL_API_KEY"  >$stdout 2>$stderr

fi
rc=$?
process_outputs $rc
exit $rc
