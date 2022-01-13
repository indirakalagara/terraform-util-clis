#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

CLI_NAME="helm"

FILENAME="helm-v3.7.2-linux-amd64.tar.gz"
TGZ_PATH="linux-amd64/helm"
if [[ "$TYPE" == "macos" ]]; then
  FILENAME="helm-v3.7.2-darwin-amd64.tar.gz"
  TGZ_PATH="darwin-amd64/helm"
fi

URL="https://get.helm.sh/$FILENAME"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${TGZ_PATH}"
