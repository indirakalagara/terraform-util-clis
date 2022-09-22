#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

CLI_NAME="ibmcloud"

function debug() {
  echo "${SCRIPT_DIR}: (${CLI_NAME}) $1" >> clis-debug.log
}

export PATH="${DEST_DIR}:${PATH}"

if "${SCRIPT_DIR}/setup-existing.sh" "${DEST_DIR}" "${CLI_NAME}"; then
  exit 0
fi

debug "Determining release"

RELEASE=$(curl -sI "https://github.com/IBM-Cloud/ibm-cloud-cli-release/releases/latest" | grep "location:" | sed -E "s~.*/tag/([a-z0-9.-]+).*~\1~g")

if [[ -z "${RELEASE}" ]]; then
  echo "ibmcloud release not found" >&2
  exit 1
fi

debug "Found release: ${RELEASE}"

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILETYPE="linux_${ARCH}"
if [[ "${TYPE}" == "macos" ]] && [[ ! "${ARCH}" =~ "arm" ]]; then
  FILETYPE="macos"
elif [[ "${TYPE}" == "macos" ]]; then
  FILETYPE="macos_${ARCH}"
fi

URL="https://download.clis.cloud.ibm.com/ibm-cloud-cli/${SHORT_RELEASE}/binaries/IBM_Cloud_CLI_${SHORT_RELEASE}_${FILETYPE}.tgz"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "IBM_Cloud_CLI/ibmcloud" version

"${DEST_DIR}/ibmcloud" config --check-version=false
