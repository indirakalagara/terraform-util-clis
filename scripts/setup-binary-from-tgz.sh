#!/usr/bin/env bash

export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
export CLI_NAME="$2"
CLI_URL="$3"
CLI_PATH="$4"

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
  debug "CLI already available in OS. Creating symlink in bin_dir"
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  TAR_FILE="${BIN_DIR}/${CLI_NAME}.tgz"

  if [[ -f "${TAR_FILE}" ]]; then
    while [[ -f "${TAR_FILE}" ]]; do
      debug "CLI is already being installed; waiting 10 seconds"
      sleep 10
    done
  else
    touch "${TAR_FILE}"

    debug "Downloading cli tar file: ${CLI_URL}"

    curl -sLo "${TAR_FILE}" "${CLI_URL}"

    if ! tar tzf "${TAR_FILE}" 1> /dev/null 2> /dev/null; then
      echo "Tar file is corrupted: ${TAR_FILE} from ${CLI_URL}" >&2
      exit 1
    fi

    if [[ ! -f "${BIN_DIR}/${CLI_NAME}" ]]; then
      debug "Unpacking ${CLI_PATH} from tar file ${TAR_FILE}"
      tar xzf "${TAR_FILE}" "${CLI_PATH}"
      debug "Installing the cli in bin_dir"
      cp "${CLI_PATH}" "${BIN_DIR}/${CLI_NAME}"
      rm "${CLI_PATH}"
    else
      debug "The CLI has already been installed. Nothing to do."
    fi

    rm "${TAR_FILE}"
    chmod +x "${BIN_DIR}/${CLI_NAME}"
  fi
fi
