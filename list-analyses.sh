#!/bin/bash
# list analysis results

HELP="usage: $0 [dateFrom-string]
  Get results from past analyses.
"

cd $(dirname ${BASH_SOURCE[0]})

# Set up API KEY
. ./common.sh

if (( $# >= 1 )) ; then
    dateFrom="\"dateFrom\": \"$1\","
    dateFrom_msg=" and dateFrom"
else
    dateFrom=""
    dateFrom_msg=""
fi

# Run the command for the analysis
prefix="GET https://api.mythril.ai/v1/analyses"
echo "Issuing HTTP $prefix
  (with MYTHRIL_API_KEY${dateFom_msg})
"
curl -i -X $prefix \
  -H "Authorization: Bearer $MYTHRIL_API_KEY" \
  -H 'Content-Type: application/json' \
  -d "{$dateFrom}" >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
