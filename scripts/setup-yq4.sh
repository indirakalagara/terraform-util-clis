#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"
VERSION="4.2"
CLI_NAME="yq"

# container images have yq4 installed as yq - find and link this to bindir/yq4
if command -v "${CLI_NAME}" 1> /dev/null 2> /dev/null && [[ $("${CLI_NAME}" --version) =~ ${VERSION} ]]; then
  COMMAND=$(command -v "${CLI_NAME}")
  mkdir -p "${DEST_DIR}"
  BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)
  ln -s "${COMMAND}" "${BIN_DIR}/yq4"
  exit 0
fi

if [[ "$TYPE" == "macos" ]]; then
  URL="https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_darwin_${ARCH}"
else
  URL="https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_${ARCH}"
fi

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" yq4 "${URL}" --version
