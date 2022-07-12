#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

function debug() {
  echo "${SCRIPT_DIR}: (all) $1" >> clis-debug.log
}

DEST_DIR="$1"
OS="$2"
ARCH="$3"

if [[ "${ARCH}" =~ ^arm ]]; then
  debug "ARM not currently supported for jq. Trying amd64"
fi

FILENAME="jq-linux64"
if [[ "${OS}" == "macos" ]]; then
  FILENAME="jq-osx-amd64"
fi

URL="https://github.com/stedolan/jq/releases/download/jq-1.6/${FILENAME}"

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" jq "${URL}" --version "1.6"
