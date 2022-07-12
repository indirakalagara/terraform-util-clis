#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

export PATH="${DEST_DIR}:${PATH}"

VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | jq -r '.tag_name // empty')

if [[ -z "${VERSION}" ]]; then
  echo "argocd release not found" >&2
  exit 1
fi

URL="https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-${ARCH}"
if [[ "$TYPE" == "macos" ]]; then
  URL="https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" argocd "${URL}" "version --client"
