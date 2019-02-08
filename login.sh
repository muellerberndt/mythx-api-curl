#!/bin/bash

me=${BASH_SOURCE[0]}

if [[ $0 == $me ]] ; then
    echo "This script should be *sourced* rather than run directly through bash"
    exit 1
fi

HELP="usage: . $me
  Login to MythX and sets a session key as an environment variable
"

if [[ "$1" =~ ^('--help'|'-h') ]] ; then
    echo "$HELP"
    return 1
fi

script_dir=$(dirname $me)
cd $script_dir
full_script_dir=$(pwd)

if [[ -z $MYTHX_ETH_ADDRESS ]] ; then
    echo >&2 "You need to set MYTHX_ETH_ADDRESS before using this script"
    return 2
fi

if [[ -z $MYTHX_PASSWORD ]] ; then
    echo >&2 "You need to set MYTHX_PASSWORD before using this script"
    return 3
fi

# Staging server is at:
# https://staging.mythx.io
MYTHX_API_URL=${MYTHX_API_URL:-https://api.mythx.io}

stdout=/tmp/curljs.out$$
stderr=/tmp/curljs.err$$

MYTHX_LOGIN=1
. ./common.sh

cmd=$(node ./login.js)
rc=$?
if (( $rc == 0 )) ; then
    eval $cmd
    if (( $rc == 0 )) ; then
	echo "Successfully logged into MythX"
	echo MYTHX_ACCESS_TOKEN set
	return
    fi
else
    echo "$cmd"
fi
return $rc
