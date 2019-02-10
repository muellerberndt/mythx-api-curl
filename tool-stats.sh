#!/bin/bash
# get tool statistics results

HELP="usage: $0 tool-name
  Get results from past analyses.

Examples:

$0 truffle # List all reports
"

cd $(dirname ${BASH_SOURCE[0]})

MYTHX_LOGIN=false
. ./common.sh

if(( $# != 1 )); then
    echo >&2 "You need to give a tool name, e.g. truffle"
    exit 1
fi

tool_name=$1

# Run the command for the analysis
cmd="curl  --header 'Content-Type: application/json' -v GET ${MYTHX_API_URL}/v1/client-tool-stats/${tool_name}"
echo "Running: $cmd"
$cmd >$stdout 2>$stderr
rc=$?
process_outputs $rc
exit $rc
