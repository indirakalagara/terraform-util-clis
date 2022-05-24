#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="x64"

if [[ -f "${DEST_DIR}/.igc-release" ]]; then
  RELEASE=$(cat "${DEST_DIR}/.igc-release")
else
  RELEASE=$(curl -s "https://api.github.com/repos/cloud-native-toolkit/git-client/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')
  echo -n "${RELEASE}" > "${DEST_DIR}/.igc-release"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" gitu "https://github.com/cloud-native-toolkit/git-client/releases/download/${RELEASE}/gitu-${TYPE}-${ARCH}"
