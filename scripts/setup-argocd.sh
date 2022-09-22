#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

CLI_NAME="argocd"

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

VERSION=$(curl -sI "https://github.com/argoproj/argo-cd/releases/latest" | grep "location:" | sed -E "s~.*/tag/([a-z0-9.-]+).*~\1~g")

if [[ -z "${VERSION}" ]]; then
  echo "argocd release not found" >&2
  exit 1
fi

URL="https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-${ARCH}"
if [[ "$TYPE" == "macos" ]]; then
  URL="https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "version --client"
