#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

function debug() {
  echo "${SCRIPT_DIR}: (all) $1" >> clis-debug.log
}

DEST_DIR="$1"
OS="$2"
ARCH="$3"

CLI_NAME="jq"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}" "1.6"; then
  exit 0
fi

if [[ "${ARCH}" =~ ^arm ]]; then
  debug "ARM not currently supported for jq. Trying amd64"
fi

FILENAME="jq-linux64"
if [[ "${OS}" == "macos" ]]; then
  FILENAME="jq-osx-amd64"
fi

URL="https://github.com/stedolan/jq/releases/download/jq-1.6/${FILENAME}"

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" --version "1.6"
