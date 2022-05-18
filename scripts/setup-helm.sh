#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

CLI_NAME="helm"

FILENAME="helm-v3.8.2-linux-${ARCH}.tar.gz"
TGZ_PATH="linux-${ARCH}/helm"
if [[ "$TYPE" == "macos" ]]; then
  FILENAME="helm-v3.8.2-darwin-${ARCH}.tar.gz"
  TGZ_PATH="darwin-${ARCH}/helm"
fi

URL="https://get.helm.sh/$FILENAME"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${TGZ_PATH}" version
