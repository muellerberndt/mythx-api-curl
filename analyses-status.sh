#!/bin/bash
# Get the status of a prior run

usage() {
    cat <<EOF
Get the status of a prior '/analyses' POST

usage: $0 UUID

EOF
    }

cd $(dirname ${BASH_SOURCE[0]})

. ./common.sh

if (( $# == 1 )) ; then
    UUID=$1
fi

if [[ -z $UUID ]] ; then
    echo >&2 "You need to either pass a UUID of a previous submitted analysis"
    usage
    exit 1
fi

prefix="GET ${MYTHX_API_URL}/v1/analyses/$UUID"
echo "Issuing HTTP $prefix
  (with ${WHAT})"

curl -i -X $prefix \
     -H "Authorization: Bearer $BEARER"  >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
