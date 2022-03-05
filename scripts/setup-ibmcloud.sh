#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

RELEASE=$(curl -s "https://api.github.com/repos/IBM-Cloud/ibm-cloud-cli-release/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILETYPE="linux_amd64"
if [[ "${TYPE}" == "macos" ]]; then
  FILETYPE="macos"
fi

URL="https://download.clis.cloud.ibm.com/ibm-cloud-cli/${SHORT_RELEASE}/binaries/IBM_Cloud_CLI_${SHORT_RELEASE}_${FILETYPE}.tgz"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" ibmcloud "${URL}" "IBM_Cloud_CLI/ibmcloud"

"${DEST_DIR}/ibmcloud" config --check-version=false
