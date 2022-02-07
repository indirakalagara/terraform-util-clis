#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

RELEASE=$(curl -s "https://api.github.com/repos/profclems/glab/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="glab_${SHORT_RELEASE}_Linux_x86_64"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="glab_${SHORT_RELEASE}_macOS_x86_64"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" glab "https://github.com/profclems/glab/releases/download/${RELEASE}/${FILENAME}.tar.gz" "bin/glab"
