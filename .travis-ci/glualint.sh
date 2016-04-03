#!/bin/sh

set -e

OUT="$(glualint --config .glualint.json .)"

echo -n "${OUT}"

if [ -z "${OUT}" ]; then
	exit 0
else
	exit 1
fi
