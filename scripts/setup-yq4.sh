#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$1"

if [[ "$TYPE" == "macos" ]]; then
  URL="https://github.com/mikefarah/yq/releases/download/v4.16.2/yq_darwin_amd64"
else
  URL="https://github.com/mikefarah/yq/releases/download/v4.16.2/yq_linux_amd64"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" yq4 "${URL}"
