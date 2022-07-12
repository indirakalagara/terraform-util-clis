#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
TYPE="$2"
ARCH="$3"

RELEASE=$(curl -s "https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest" | "${DEST_DIR}/jq" -r '.tag_name // empty')

if [[ -z "${RELEASE}" ]]; then
  echo "kubeseal release not found" >&2
  exit 1
fi

SHORT_RELEASE=$(echo "${RELEASE}" | sed -E "s/v//g")

FILENAME="kubeseal-${SHORT_RELEASE}-linux-${ARCH}"
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="kubeseal-${SHORT_RELEASE}-darwin-${ARCH}"
fi

URL="https://github.com/bitnami-labs/sealed-secrets/releases/download/${RELEASE}/${FILENAME}.tar.gz"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" kubeseal "${URL}" kubeseal --version
