#!/usr/bin/env bash

export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

BIN_DIR="$1"
export PLUGIN_NAME="$2"

function debug() {
  echo "${SCRIPT_DIR}: ibmcloud-${PLUGIN_NAME} $1" >> clis-debug.log
}

if "${BIN_DIR}/ibmcloud" plugin show "${PLUGIN_NAME}" 1> /dev/null 2> /dev/null; then
  debug "Plugin already installed"
  exit 0
fi

TMP_FILE="${BIN_DIR}/${PLUGIN_NAME}.tmp"

if [[ -f "${TMP_FILE}" ]]; then
  while [[ -f "${TMP_FILE}" ]]; do
    debug "Plugin is already being installed; waiting 10 seconds"
    sleep 10
  done
else
  echo -n "$0" > "${TMP_FILE}"

  sleep 1
  if [[ "$(cat "${TMP_FILE}")" == "$0" ]]; then
    debug "Installing plugin"
    ${BIN_DIR}/ibmcloud plugin install "${PLUGIN_NAME}" 1> /dev/null
    rm "${TMP_FILE}"
  else
    while [[ -f "${TMP_FILE}" ]]; do
      debug "Plugin is already being installed; waiting 10 seconds"
      sleep 10
    done
  fi
fi
