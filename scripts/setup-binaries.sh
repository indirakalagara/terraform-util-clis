#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

INPUT=$(tee)

DEST_DIR=$(echo "${INPUT}" | grep bin_dir | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')
CLIS=$(echo "${INPUT}" | grep clis | sed -E 's/.*"clis": ?"([^"]*)".*/\1/g')

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
  echo '{"status": "error", "message": "OS not supported"}'
  exit 1
fi

"${SCRIPT_DIR}/setup-jq.sh" "${DEST_DIR}" "${TYPE}" || exit 1

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

if [[ "${CLIS}" =~ rosa ]]; then
  "${SCRIPT_DIR}/setup-rosa.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ gh ]]; then
  "${SCRIPT_DIR}/setup-gh.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ glab ]]; then
  "${SCRIPT_DIR}/setup-glab.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ kubeseal ]]; then
  "${SCRIPT_DIR}/setup-kubeseal.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ oc ]] || [[ "${CLIS}" =~ kubectl ]]; then
  "${SCRIPT_DIR}/setup-oc.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

echo "{\"status\": \"success\", \"message\": \"success\", \"type\": \"${type}\", \"bin_dir\": \"${DEST_DIR}\"}"
