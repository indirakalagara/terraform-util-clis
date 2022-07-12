#!/usr/bin/env bash

export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
export CLI_NAME="$2"
CLI_URL="$3"
TEST_ARGS="${4:---version}"
VERSION_MATCH="$5"

function debug() {
  echo "${SCRIPT_DIR}: (${CLI_NAME}) $1" >> clis-debug.log
}

if [[ -z "${UUID}" ]]; then
  UUID="xxxxxx"
fi

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
  debug "CLI already available in PATH. Creating symlink in bin_dir"
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  SEMAPHORE="${BIN_DIR}/${CLI_NAME}.semaphore"
  TMP_FILE="${BIN_DIR}/${CLI_NAME}-${UUID}.tmp"

  if [[ -f "${SEMAPHORE}" ]]; then
    while [[ -f "${SEMAPHORE}" ]]; do
      debug "CLI is already being installed; waiting 10 seconds"
      sleep 10
    done
  else
    echo -n "${UUID}" > "${SEMAPHORE}"

    count=0
    while ! command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null && \
      ! "${BIN_DIR}/${CLI_NAME}" ${TEST_ARGS} 1> /dev/null 2> /dev/null && \
      [[ ${count} -lt 3 ]]
    do
      count=$((count + 1))

      debug "Downloading cli: ${CLI_URL}"

      curl -sLo "${TMP_FILE}" "${CLI_URL}"

      if [[ ! -f "${BIN_DIR}/${CLI_NAME}" ]]; then
        debug "Installing the cli in bin_dir"
        cp "${TMP_FILE}" "${BIN_DIR}/${CLI_NAME}"
      else
        debug "The CLI has already been installed. Nothing to do."
      fi

      chmod +x "${BIN_DIR}/${CLI_NAME}"
    done

    rm -f "${TMP_FILE}" 1> /dev/null 2> /dev/null
    rm -f "${SEMAPHORE}" 1> /dev/null 2> /dev/null

    if ! "${BIN_DIR}/${CLI_NAME}" ${TEST_ARGS} 1> /dev/null 2> /dev/null; then
      echo "Error downloading ${CLI_NAME} from ${CLI_URL}" >&2
      exit 1
    fi
  fi
fi
