#!/bin/bash
set -eu
set -o pipefail

CONFIG=
FQDN=
TOKEN=
IP=
QUIET=

if [ -r /etc/regfish-dyndns.conf ]; then
	CONFIG=/etc/regfish-dyndns.conf
fi

function usage() {
	echo "$0 [OPTIONS]"
	echo "  --config FILE   Config file name"
	echo "  --fqdn DOMAIN   Domain name"
	echo "  --token TOKEN   Regfish dyndns token"
	echo "  --ip IP         IP address (optional)"
	echo "  --quiet         Don't show output on success"
}

while (( $# )); do
	case "$1" in
		--config|-c)
			CONFIG="$2"
			shift 2
			;;
		--config=*)
			CONFIG="${1#--config=}"
			shift
			;;
		--fqdn|-d)
			FQDN_ARG="$2"
			shift 2
			;;
		--fqdn=*)
			FQDN_ARG="${1#--fqdn=}"
			shift
			;;
		--token|-t)
			TOKEN_ARG="$2"
			shift 2
			;;
		--token=*)
			TOKEN_ARG="${1#--token=}"
			shift
			;;
		--ip|-i)
			IP_ARG="$2"
			shift 2
			;;
		--ip=*)
			IP_ARG="${1#--ip=}"
			shift
			;;
		--quiet|-q)
			QUIET=1
			shift
			;;
		*)
			echo "Unknown option: $1" 1>&2
			usage &2>1
			exit 1
			;;
	esac
done

if [ -n "$CONFIG" ]; then
	source "$CONFIG"
fi

if [ -v FQDN_ARG ]; then
	FQDN="$FQDN_ARG"
fi
if [ -d TOKEN_ARG ]; then
	TOKEN="$TOKEN_ARG"
fi
if [ -d IP_ARG ]; then
	IP="$IP_ARG"
fi

if [ -n "$IP" ]; then
	IP_URLPARAM="ipv4=$IP"
else
	IP_URLPARAM="thisipv4=1"
fi


# We pass the GET parameters through stdin instead of adding them to the
# URL directly. This makes sure the $TOKEN doesn't show up in the command
# line where everybody could see it.
RESP=$(curl -sS --data '@-' "https://dyndns.regfish.de/" <<<"fqdn=$FQDN&token=$TOKEN&$IP_URLPARAM")
if echo "$RESP" | grep -q '|10.|'; then
	if [ -z "$QUIET" ]; then
		echo "$RESP"
	fi
else
	echo "$RESP" 1>&2
	exit 1
fi
