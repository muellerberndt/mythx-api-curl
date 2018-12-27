#!/bin/bash
# Run an analysis

usage() {
    cat <<EOF
submit *json-file* for analyses.

usage: $0 *json-file*
EOF
}

cd $(dirname ${BASH_SOURCE[0]})

# Set up authentication
. ./common.sh

if(( $# != 1 )); then
    echo >&2 "You need to either pass a JSON file. e.g. sample-json/PublicArray.json"
    exit 1
fi

json_path=$1
if [[ ! -f "$json_path" ]] ; then
    echo >&2 "Can't find JSON file: $json_path"
    usage
    exit 1
fi

prefix="POST ${MYTHRIL_API_URL}/v1/analyses"
if [[ -n $MYTHRIL_ACCESS_TOKEN ]] ; then
    # Run the command for the analysis
    echo "Issuing HTTP $prefix
  (with MYTHRIL_ACCESS_TOKEN on file $json_path)
"
    curl -i -X $prefix \
	 -H "Authorization: Bearer $MYTHRIL_ACCESS_TOKEN" \
	 -H 'Content-Type: application/json' \
	 -d "$(cat $json_path)" >$stdout 2>$stderr
else
    echo "Issuing HTTP $prefix
  (with MYTHRIL_API_KEY on file $json_path)
"
    curl -i -X $prefix \
	 -H "Authorization: Bearer $MYTHRIL_API_KEY" \
	 -H 'Content-Type: application/json' \
	 -d "$(cat $json_path)" >$stdout 2>$stderr
fi
rc=$?
process_outputs $rc
exit $rc
