#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

FILETYPE="linux"
if [[ "${TYPE}" == "macos" ]]; then
  FILETYPE="mac"
fi

URL="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-${FILETYPE}.tar.gz"

CMD_NAME="oc"
if [[ "${TYPE}" == "alpine" ]] && [[ ! -f /lib/libgcompat.so.0 ]]; then
  CMD_NAME="oc-bin"
fi

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CMD_NAME}" "${URL}" oc

if [[ "${TYPE}" == "alpine" ]] && [[ ! -f /lib/libgcompat.so.0 ]]; then
  echo "/lib/ld-musl-x86_64.so.1 --library-path /lib ${DEST_DIR}/oc-bin \$@" > ${DEST_DIR}/oc
  chmod +x "${DEST_DIR}/oc"
fi

if [[ ! -e "${DEST_DIR}/kubectl" ]]; then
  ln "${DEST_DIR}/oc" "${DEST_DIR}/kubectl" 1> /dev/null 2> /dev/null || echo -n ''
fi
