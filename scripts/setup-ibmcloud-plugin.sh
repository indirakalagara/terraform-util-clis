#!/usr/bin/env bash

BIN_DIR="$1"
PLUGIN_NAME="$2"

if "${BIN_DIR}/ibmcloud" plugin show "${PLUGIN_NAME}" 1> /dev/null 2> /dev/null; then
  exit 0
fi

TMP_FILE="${BIN_DIR}/${PLUGIN_NAME}.tmp"

if [[ -f "${TMP_FILE}" ]]; then
  while [[ -f "${TMP_FILE}" ]]; do
    sleep 10
  done
else
  echo -n "$0" > "${TMP_FILE}"

  sleep 1
  if [[ "$(cat "${TMP_FILE}")" == "$0" ]]; then
    ${BIN_DIR}/ibmcloud plugin install "${PLUGIN_NAME}" 1> /dev/null
    rm "${TMP_FILE}"
  else
    while [[ -f "${TMP_FILR}" ]]; do
      sleep 10
    done
  fi
fi
