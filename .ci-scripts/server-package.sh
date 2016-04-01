#!/bin/sh

git archive --format tar HEAD | tar -x -C server-content
