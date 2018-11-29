# -*- shell-script -*-
if [[ "$1" =~ ^('--help'|'-h') ]] ; then
    echo "$HELP"
    exit 100
fi

if [[ -z $MYTHRIL_ACCESS_TOKEN ]] ; then
    echo >&2 "source login to set MYTHRIL_ACCESS_TOKEN before using this script"
    exit 1
fi

# Staging server is at:
# https://staging.api.mythril.ai:3100
MYTHRIL_API_URL=${MYTHRIL_API_URL:-https://api.mythril.ai}

stdout=/tmp/curljs.out$$
stderr=/tmp/curljs.err$$

# Run curl and format JSON output if there's nothing wrong
process_outputs() {
    typeset rc=$1
    typeset use_jq=${2:-1}

    if (( $rc == 0 )) ; then
	echo "curl completed sucessfully. Output follows..."
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
