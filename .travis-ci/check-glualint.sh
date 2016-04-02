#!/bin/sh

set -e

if [ -z "$1" ]; then
	CHECK_DIR="."
else
	CHECK_DIR="$1"
fi

OUT="$(glualint --config .glualint.json "${CHECK_DIR}")"

echo -n "${OUT}"

if [ -z "${OUT}" ]; then
	exit 0
else
	exit 1
fi
