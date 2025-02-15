#!/bin/bash

set -xueo pipefail

if [[ $# -ne 1 ]]; then
	echo "tag is required"
	echo "$0: <tag>"
	exit 255
fi

LABEL=$1

# docker tag portal docker.svc.home.lan/home/portal:${LABEL}

pushd deploy
kustomize edit set image ghcr.io/goraxe/portal=ghcr.io/goraxe/portal:"${LABEL}"
cat kustomization.yaml
kustomize build
popd

exit
