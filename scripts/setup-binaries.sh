#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"

"${SCRIPT_DIR}/setup-jq.sh" "${DEST_DIR}" || exit 1
"${SCRIPT_DIR}/setup-igc.sh" "${DEST_DIR}" || exit 1
"${SCRIPT_DIR}/setup-yq3.sh" "${DEST_DIR}" || exit 1
"${SCRIPT_DIR}/setup-yq4.sh" "${DEST_DIR}" || exit 1
