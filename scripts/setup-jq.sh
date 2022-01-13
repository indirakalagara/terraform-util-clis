#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
OS="$2"

FILENAME="jq-linux64"
if [[ "${OS}" == "macos" ]]; then
  FILENAME="jq-osx-amd64"
fi

URL="https://github.com/stedolan/jq/releases/download/jq-1.6/${FILENAME}"

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" jq "${URL}"
