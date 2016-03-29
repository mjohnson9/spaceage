#!/bin/sh

set -e

find . -type f -iname '*.lua' -not -iwholename '*.git*' | while read filepath; do
	luac5.1 -p -- "${filepath}"
done
