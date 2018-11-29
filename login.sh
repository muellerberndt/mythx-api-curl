#!/bin/bash

if [[ $0 == ${BASH_SOURCE[0]} ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi

echo ${BASH_SOURCE[0]}
HELP="usage: . ${BASH_SOURCE[0]}
  Login to MythX and sets a session key as an environment variable
"

if [[ "$1" =~ ^('--help'|'-h') ]] ; then
    echo "$HELP"
    return 1
fi

script_dir=$(dirname ${BASH_SOURCE[0]})
cd $script_dir
full_script_dir=$(pwd)
echo $full_script_dir

if [[ -z $MYTHRIL_ETH_ADDRESS ]] ; then
    echo >&2 "You need to set MYTHRIL_ETH_ADDRESS before using this script"
    return 2
fi

if [[ -z $MYTHRIL_PASSWORD ]] ; then
    echo >&2 "You need to set MYTHRIL_PASSWORD before using this script"
    return 3
fi

# Staging server is at:
# https://staging.api.mythril.ai:3100
MYTHRIL_API_URL=${MYTHRIL_API_URL:-https://api.mythril.ai}

stdout=/tmp/curljs.out$$
stderr=/tmp/curljs.err$$
. ./common.sh

eval $(node ./login.js)
rc=$?
if (( $rc == 0 )) ; then
    echo "Successfully logged into MythX"
    echo MYTHRIL_ACCESS_TOKEN and MYTHRIL_REFRESH_TOKEN set
    return
fi
return $rc
