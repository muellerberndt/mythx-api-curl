#!/bin/bash
# Run an analysis

HELP="usage: $0 *json-file*
  submit *json-file* for analyses.
"

cd $(dirname ${BASH_SOURCE[0]})

# Set up API KEY
. ./common.sh

if(( $# != 1 )); then
    echo >&2 "You need to either pass a JSON file. e.g. sample-json/PublicArray.json"
    exit 1
fi

json_path=$1
if [[ ! -f "$json_path" ]] ; then
    echo >&2 "Can't find JSON file: $json_path"
    exit 1
fi


# Run the command for the analysis
prefix="POST ${MYTHRIL_API_URL}/v1/analyses"
echo "Issuing HTTP $prefix
  (with MYTHRIL_ACCESS_TOKEN on file $json_path)
"
curl -i -X $prefix \
  -H "Authorization: Bearer $MYTHRIL_ACCESS_TOKEN" \
  -H 'Content-Type: application/json' \
  -d "$(cat $json_path)" >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
