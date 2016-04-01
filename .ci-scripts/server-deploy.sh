#!/bin/bash

set -e

if [ -z "$1" ]; then
	echo "usage: $0 <mode>"
	exit 1
fi

DEPLOY_TO="DEPLOY_TO_${1}"
if [ -z "${!DEPLOY_TO}" ]; then
	echo "unknown mode: $1"
	exit 1
fi

eval $(ssh-agent -s)
ssh-add <(echo "${SSH_PRIVATE_KEY}")

mkdir -p ~/.ssh
chmod 0700 ~/.ssh

echo "${KNOWN_HOSTS}" > ~/.ssh/known_hosts

TEMP_DIR="$(mktemp -d --suffix .server-deploy)"
function finish {
	rm -rf "${TEMP_DIR}"
}
trap finish EXIT

tar -x -C "${TEMP_DIR}" -f "server.tar"

FAILED=0

while read -r deploy_host; do
	echo "Deploying to: ${deploy_host}"
	rsync -a --delete "${TEMP_DIR}/" "${deploy_host}"
	status=$?
	if [ $status -ne 0 ]; then
		FAILED=1
		echo "Failed to deploy to ${deploy_host}"
	fi
done <<< "${!DEPLOY_TO}"

exit ${FAILED}
