#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
CLIS="$2"

TYPE="linux"
OS=$(uname)
if [[ "$OS" == "Linux" ]]; then
  TYPE=$(cat /etc/os-release | grep -E "^ID=" | sed "s/ID=//g")
  if [[ "${TYPE}" != "alpine" ]]; then
    TYPE="linux"
  fi
elif [[ "$OS" == "Darwin" ]]; then
  TYPE="macos"
else
  echo "OS not supported"
  exit 1
fi

echo "*** Identified OS: ${TYPE}"

if [[ "${CLIS}" =~ jq ]]; then
  "${SCRIPT_DIR}/setup-jq.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ igc ]]; then
  "${SCRIPT_DIR}/setup-igc.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ yq ]]; then
  "${SCRIPT_DIR}/setup-yq3.sh" "${DEST_DIR}" "${TYPE}" || exit 1
  "${SCRIPT_DIR}/setup-yq4.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ helm ]]; then
  "${SCRIPT_DIR}/setup-helm.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ argocd ]]; then
  "${SCRIPT_DIR}/setup-argocd.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi
