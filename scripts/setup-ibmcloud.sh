#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

function debug() {
  CLI_NAME="ibmcloud"
  echo "${SCRIPT_DIR}: (${CLI_NAME}) $1" >> clis-debug.log
}

export PATH="${DEST_DIR}:${PATH}"

debug "Determining release"

RELEASE=$(curl -s "https://api.github.com/repos/IBM-Cloud/ibm-cloud-cli-release/releases/latest" | jq -r '.tag_name // empty')

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

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" ibmcloud "${URL}" "IBM_Cloud_CLI/ibmcloud" version

"${DEST_DIR}/ibmcloud" config --check-version=false
