#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

if [[ "$TYPE" == "macos" ]]; then
  URL="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_darwin_${ARCH}"
else
  URL="https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" yq3 "${URL}" --version
