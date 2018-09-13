#!/bin/bash

HELP="usage: $0
  Gets OpenAPI specification
"

cd $(dirname ${BASH_SOURCE[0]})

. ./common.sh

prefix="GET https://api.mythril.ai/v1/openapi.yaml"
echo "Issuing HTTP $prefix"

curl -i -X $prefix >$stdout 2>$stderr
rc=$?

if (( $rc == 0 )) ; then
    echo "curl completed sucessfully. Output follows..."
    if [[ -s $stdout ]] ; then
	cat $stdout | grep "^HTTP"

	echo -----------------------------------
	grep -A 1000 ^openapi $stdout
    fi
fi

exit $rc
