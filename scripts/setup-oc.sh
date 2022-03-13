#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

OC_FILETYPE="linux"
KUBECTL_FILETYPE="linux"
if [[ "${TYPE}" == "macos" ]]; then
  OC_FILETYPE="mac"
  KUBECTL_FILETYPE="darwin"
fi

OC_URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-${OC_FILETYPE}.tar.gz"
KUBECTL_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${KUBECTL_FILETYPE}/amd64/kubectl"

CMD_NAME="oc"
if [[ "${TYPE}" == "alpine" ]] && [[ ! -f /lib/libgcompat.so.0 ]]; then
  CMD_NAME="oc-bin"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CMD_NAME}" "${OC_URL}" oc

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" "kubectl" "${KUBECTL_URL}"

if [[ "${TYPE}" == "alpine" ]] && [[ ! -f /lib/libgcompat.so.0 ]]; then
  echo "/lib/ld-musl-x86_64.so.1 --library-path /lib ${DEST_DIR}/oc-bin \$@" > ${DEST_DIR}/oc
  chmod +x "${DEST_DIR}/oc"
fi
