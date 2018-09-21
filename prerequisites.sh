#!/usr/bin/env bash
set -e
if [[ $SHELL =~ bash ]]; then
    echo Okay: you seem to have bash installed.
else
    echo '$SHELL does not think you have bash installed'
    exit 1
fi

if ! which curl ; then
    echo 'Curl not installed.
Install via your OS package manager or look at https://curl.haxx.se/download.html
'
    exit 2
else
    echo Good: seem to have curl installed.
fi


if ! which jq ; then
    echo 'jq not installed.
Install via your OS package manager or look at https://stedolan.github.io/jq/download/
'
    exit 3
else
    echo Great: you seem to have jq installed.
fi

echo "WOOT! You seem to have everything needed to run these scripts"
exit 0
