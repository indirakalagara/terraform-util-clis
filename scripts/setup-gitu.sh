#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

CLI_NAME="gitu"

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

RELEASE=$(curl -sI "https://github.com/cloud-native-toolkit/git-client/releases/latest" | grep "location:" | sed -E "s~.*/tag/([a-z0-9.-]+).*~\1~g")

if [[ -z "${RELEASE}" ]]; then
  echo "gitu release not found" >&2
  exit 1
fi

# Work around different suffix for gitu release
if [[ "${ARCH}" == "amd64" ]]; then
  ARCH="x64"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "${CLI_NAME}" "https://github.com/cloud-native-toolkit/git-client/releases/download/${RELEASE}/gitu-${TYPE}-${ARCH}" --version
