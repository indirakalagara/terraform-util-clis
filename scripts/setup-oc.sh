#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

RELEASE=$(curl -s "https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILETYPE="linux"
if [[ "${TYPE}" == "macos" ]]; then
  FILETYPE="mac"
fi

URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-${FILETYPE}.tar.gz"

echo "Getting oc from ${URL}"

CMD_NAME="oc"
if [[ "${TYPE}" == "alpine" ]]; then
  CMD_NAME="oc-bin"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CMD_NAME}" "${URL}" oc

if [[ "${TYPE}" == "alpine" ]]; then
  echo "/lib/ld-musl-x86_64.so.1 --library-path /lib ${DEST_DIR}/oc-bin \$@" > ${DEST_DIR}/oc
  chmod +x "${DEST_DIR}/oc"
fi

ln -s "${DEST_DIR}/oc" "${DEST_DIR}/kubectl"
