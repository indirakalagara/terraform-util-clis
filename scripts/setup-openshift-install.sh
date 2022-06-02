#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"
VERSION="$4"

OC_ARCH=$(uname -m)

OC_FILETYPE="linux"
if [[ "${TYPE}" == "macos" ]]; then
  OC_FILETYPE="mac"
fi

if [[ -z "${VERSION}" ]] || [[ "${VERSION}" == "4" ]]; then
  OC_URL="https://mirror.openshift.com/pub/openshift-v4/${OC_ARCH}/clients/ocp/stable/openshift-install-${OC_FILETYPE}.tar.gz"
elif [[ "${VERSION}" =~ [0-9][.][0-9]+[.][0-9]+ ]]; then
  OC_URL="https://mirror.openshift.com/pub/openshift-v4/${OC_ARCH}/clients/ocp/${VERSION}/openshift-install-${OC_FILETYPE}.tar.gz"
else
  OC_URL="https://mirror.openshift.com/pub/openshift-v4/${OC_ARCH}/clients/ocp/stable-${VERSION}/openshift-install-${OC_FILETYPE}.tar.gz"
fi

CMD_NAME="openshift-install"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CMD_NAME}" "${OC_URL}" openshift-install "version"
