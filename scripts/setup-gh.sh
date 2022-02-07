#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

RELEASE=$(curl -s "https://api.github.com/repos/cli/cli/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="gh_${SHORT_RELEASE}_linux_amd64"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="gh_${SHORT_RELEASE}_macOS_amd64"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" gh "https://github.com/cli/cli/releases/download/${RELEASE}/${FILENAME}.tar.gz" "${FILENAME}/bin/gh"
