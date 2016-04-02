#!/bin/sh

RETURN_STATUS=0

for filepath in $(find . -type f -iname '*.lua' -not -iwholename '*.git*'); do
	luac5.1 -p -- "${filepath}"
	status=$?
	if [ $status -ne 0 ]; then
		RETURN_STATUS=1
	fi
done

exit $RETURN_STATUS
