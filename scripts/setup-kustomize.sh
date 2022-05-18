#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

CLI_NAME="kustomize"

FILENAME="kustomize_v4.5.4_linux_${ARCH}.tar.gz"
if [[ "$TYPE" == "macos" ]]; then
  FILENAME="kustomize_v4.5.4_darwin_${ARCH}.tar.gz"
fi

URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.4/$FILENAME"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${CLI_NAME}" version
