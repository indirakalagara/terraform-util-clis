#!/usr/bin/env bash

export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
export CLI_NAME="$2"
VERSION_MATCH="$3"

function debug() {
  echo "${SCRIPT_DIR}: (${CLI_NAME}) $1" >> clis-debug.log
}

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

if command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  debug "CLI already provided in bin_dir"
  exit 0
fi

if command -v "${CLI_NAME}" 1> /dev/null 2> /dev/null && [[ -n "${VERSION_MATCH}" ]] && [[ $("${CLI_NAME}" --version) =~ ${VERSION_MATCH} ]]; then
  COMMAND=$(command -v "${CLI_NAME}")
else
  COMMAND=$(command -v "${CLI_NAME}")
fi

if [[ -n "${COMMAND}" ]]; then
  debug "CLI already available in PATH. Creating symlink in ${BIN_DIR}"
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
else
  exit 1
fi
