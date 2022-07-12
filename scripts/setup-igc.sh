#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

export PATH="${DEST_DIR}:${PATH}"

RELEASE=$(curl -s "https://api.github.com/repos/cloud-native-toolkit/ibm-garage-cloud-cli/releases/latest" | jq -r '.tag_name // empty')

if [[ -z "${RELEASE}" ]]; then
  echo "igc release not found" >&2
  exit 1
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" igc "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/download/${RELEASE}/igc-${TYPE}" --version
