#!/usr/bin/env bash

export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
export CLI_NAME="$2"
CLI_URL="$3"

function debug() {
  echo "${SCRIPT_DIR}: (${CLI_NAME}) $1" >> clis-debug.log
}

mkdir -p "${DEST_DIR}"

BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

if command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  debug "CLI already provided in bin_dir"
  exit 0
fi

COMMAND=$(command -v "${CLI_NAME}")

if [[ -n "${COMMAND}" ]]; then
  debug "CLI already available in PATH. Creating symlink in bin_dir"
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  TMP_FILE="${BIN_DIR}/${CLI_NAME}.tmp"

  if [[ -f "${TMP_FILE}" ]]; then
    while [[ -f "${TMP_FILE}" ]]; do
      debug "CLI is already being installed; waiting 10 seconds"
      sleep 10
    done
  else
    touch "${TMP_FILE}"

    debug "Downloading cli: ${CLI_URL}"

    curl -sLo "${TMP_FILE}" "${CLI_URL}"

    if [[ ! -f "${BIN_DIR}/${CLI_NAME}" ]]; then
      debug "Installing the cli in bin_dir"
      cp "${TMP_FILE}" "${BIN_DIR}/${CLI_NAME}"
    else
      debug "The CLI has already been installed. Nothing to do."
    fi

    chmod +x "${BIN_DIR}/${CLI_NAME}"
    rm -f "${TMP_FILE}"
  fi
fi
