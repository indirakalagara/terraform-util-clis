#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

CLI_NAME="gh"

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

RELEASE=$(curl -sI "https://github.com/cli/cli/releases/latest" | grep "location:" | sed -E "s~.*/tag/([a-z0-9.-]+).*~\1~g")

if [[ -z "${RELEASE}" ]]; then
  echo "gh release not found" >&2
  exit 1
fi

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="gh_${SHORT_RELEASE}_linux_${ARCH}"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="gh_${SHORT_RELEASE}_macOS_${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "https://github.com/cli/cli/releases/download/${RELEASE}/${FILENAME}.tar.gz" "${FILENAME}/bin/gh" --version
