#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
CLI_NAME="igc"

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

RELEASE=$(curl -sI "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/latest" | grep "location:" | sed -E "s~.*/tag/([a-z0-9.-]+).*~\1~g")

if [[ -z "${RELEASE}" ]]; then
  echo "igc release not found" >&2
  exit 1
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "${CLI_NAME}" "https://github.com/cloud-native-toolkit/ibm-garage-cloud-cli/releases/download/${RELEASE}/igc-${TYPE}" --version
