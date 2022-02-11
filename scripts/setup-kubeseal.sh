#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"

RELEASE=$(curl -s "https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name')

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="kubeseal-${SHORT_RELEASE}-linux-amd64"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="kubeseal-${SHORT_RELEASE}-darwin-amd64"
fi

URL="https://github.com/bitnami-labs/sealed-secrets/releases/download/${RELEASE}/${FILENAME}.tar.gz"

echo "Getting kubeseal from ${URL}"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" kubeseal "${URL}" kubeseal
