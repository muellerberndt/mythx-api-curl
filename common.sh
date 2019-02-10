# -*- shell-script -*-
if [[ "$1" =~ ^('--help'|'-h') ]] ; then
    echo "$HELP"
    exit 100
fi

if [[ -z $MYTHX_API_KEY ]] ; then
    if [[ -z $MYTHX_ACCESS_TOKEN ]] && [[ -z $MYTHX_LOGIN ]] ; then
	echo >&2 "Source login to set MYTHX_ACCESS_TOKEN before using this script"
	exit 1
    fi
fi

if [[ -n $MYTHX_ACCESS_TOKEN ]] ; then
    WHAT=MYTHX_ACCESS_TOKEN
    BEARER="$MYTHX_ACCESS_TOKEN"
else
    WHAT=MYTHX_API_KEY
    BEARER="$MYTHX_API_KEY"
fi


# Staging server is at:
# https://staging.mythx.io
MYTHX_API_URL=${MYTHX_API_URL:-https://api.mythx.io}

stdout=/tmp/curljs.out$$
stderr=/tmp/curljs.err$$

# Run curl and format JSON output if there's nothing wrong
process_outputs() {
    typeset rc=$1
    typeset use_jq=${2:-1}

    if (( $rc == 0 )) ; then
	results=$(cat $stdout)
	case $results in
	    '{"status":401,"error":"Not authenticated"}' )
		echo "Not authenticated (HTTP 401)"
		return 41
		;;
	    'Unauthorized' )
		echo "Not authorized to perform this request."
		return 41
	esac

	echo "curl completed sucessfully. See $stderr for verbose logs."
	echo "Processed output from $stdout follows..."
	if [[ -s $stdout ]] ; then
	    cat $stdout | grep "^HTTP"
	    if (( use_jq )) ; then
		if ! grep '^[{[]' $stdout | jq 2>/dev/null ; then
		    echo -----------------------------------
		    cat $stdout
		    echo
		fi
	    else
		# version does this. The result isn't JSON, but a single field
		# Is this a bug in the API?
		if ! grep -A 2 '\n\n' $stdout | tail -1 2>/dev/null ; then
		    echo -----------------------------------
		    cat $stdout
		    echo
		fi
	    fi
	fi
    else
	if [[ -s $stderr ]] ; then
	    cat $stderr
	fi
	if [[ -s $stdout ]] ; then
	    cat $stdout
	    fi
	return $?
    fi
}
