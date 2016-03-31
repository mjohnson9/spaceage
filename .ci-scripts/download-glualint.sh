#!/bin/sh

set -e
mkdir -p .bin
curl -Lo .bin/glualint.zip 'https://github.com/FPtje/GLuaFixer/releases/download/1.6.5/glualint-Linux-1.6.5.zip'
unzip -o .bin/glualint.zip -d .bin
rm .bin/glualint.zip
chmod a+x .bin/glualint
echo -n "glualint version: "
.bin/glualint --version
