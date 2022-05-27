#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

CLI_NAME="kustomize"

FILENAME="kustomize_v4.5.4_linux_amd64.tar.gz"
if [[ "$TYPE" == "macos" ]]; then
  FILENAME="kustomize_v4.5.4_darwin_amd64.tar.gz"
fi

URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.4/$FILENAME"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${CLI_NAME}" version
