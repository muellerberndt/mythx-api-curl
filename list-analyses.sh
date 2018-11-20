#!/bin/bash
# list analysis results

HELP="usage: $0 queryparams
  Get results from past analyses.

queryparams can include offset, dateFrom, and dateTo parameters:

offset - integer pagenation offset, number of records to skip
dateFrom - A millisecond integer or valid date string that indicates
           the earliest time to report from
dateTo - A millisecond integer or valid ISO 8601 Date string that indicates
         the most recent time from which reporting should stop after

Examples:

$0 # List all reports
$0 'dateFrom=2018-09-014T14&dateTo=2018-09-15'
"

cd $(dirname ${BASH_SOURCE[0]})

# Set up API KEY
. ./common.sh

if (( $# >= 1 )) ; then
    query_params="?$1"
else
    query_params=""
fi

# Run the command for the analysis
prefix="GET ${MYTHRIL_API_URL}/v1/analyses$query_params"
echo "Issuing HTTP $prefix
  (with MYTHRIL_API_KEY${dateFom_msg})
"
curl -i -X $prefix \
  --header "Authorization: Bearer $MYTHRIL_API_KEY" \
  --header 'Content-Type: application/json' \
  --data-ascii "{$dateFrom}" >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
