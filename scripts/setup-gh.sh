#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

export PATH="${DEST_DIR}:${PATH}"

RELEASE=$(curl -s "https://api.github.com/repos/cli/cli/releases/latest" | jq -r '.tag_name // empty')

if [[ -z "${RELEASE}" ]]; then
  echo "gh release not found" >&2
  exit 1
fi

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="gh_${SHORT_RELEASE}_linux_${ARCH}"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="gh_${SHORT_RELEASE}_macOS_${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" gh "https://github.com/cli/cli/releases/download/${RELEASE}/${FILENAME}.tar.gz" "${FILENAME}/bin/gh" --version
