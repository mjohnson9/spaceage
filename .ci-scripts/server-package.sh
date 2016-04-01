#!/bin/sh

set -e

rm -rf server-content
mkdir -p server-content
git archive --format tar HEAD | tar -x -C server-content
