#!/bin/bash

TEMP_FILE="$(mktemp)"
function finish {
	# Remove our temporary file
	rm -f -- "${TEMP_FILE}"
}
trap finish EXIT

RETURN_STATUS=0

for filepath in $(find . -type f -iname '*.lua' -not -iwholename '*.git*'); do
	.bin/glualint --config .glualint.json --pretty-print < "${filepath}" > "${TEMP_FILE}"
	status=$?
	if [ $status -eq 0 ]; then
		cat "${TEMP_FILE}" > "${filepath}"
		# glualint doesn't print the trailing newline
		echo > "${filepath}"
		echo "Formatted ${filepath}"
	else
		echo "Failed to format ${filepath}"
		RETURN_STATUS=1
	fi
done

exit $RETURN_STATUS
