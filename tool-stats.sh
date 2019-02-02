#!/bin/bash
# get tool statistics results

HELP="usage: $0 tool-name
  Get results from past analyses.

Examples:

$0 truffle # List all reports
"

cd $(dirname ${BASH_SOURCE[0]})

. ./common.sh

if(( $# != 1 )); then
    echo >&2 "You need to give a tool name, e.g. truffle"
    exit 1
fi

tool_name=$1

# Run the command for the analysis
prefix="GET ${MYTHX_API_URL}/v1/client-tool-stats/${tool_name}"

echo "Issuing HTTP $prefix"
curl -i -X $prefix \
  --header 'Content-Type: application/json' >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
