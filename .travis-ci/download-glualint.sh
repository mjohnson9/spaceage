#!/bin/sh

set -e

if [ -z "$1" ]; then
	echo "usage: $0 <folder to put glualint in>"
	exit 1
fi

TARGET_DIR="$1"

curl -Lo "${TARGET_DIR}/glualint.zip" 'https://github.com/FPtje/GLuaFixer/releases/download/1.6.5/glualint-Linux-1.6.5.zip'
unzip -o "${TARGET_DIR}/glualint.zip" -d "${TARGET_DIR}"
rm "${TARGET_DIR}/glualint.zip"
chmod a+x "${TARGET_DIR}/glualint"
echo -n "glualint version: "
"${TARGET_DIR}/glualint" --version
