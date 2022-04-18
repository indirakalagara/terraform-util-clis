#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

INPUT=$(tee)

function debug() {
  echo "${SCRIPT_DIR}: (all) $1" >> clis-debug.log
}

debug "Input: ${INPUT}"

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
  echo '{"status": "error", "message": "OS not supported"}' >&2
  exit 1
fi

debug "Detected os type: ${TYPE}"

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

if [[ "${CLIS}" =~ ibmcloud ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud-is ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud-plugin.sh" "${DEST_DIR}" infrastructure-service || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud-ob ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud-plugin.sh" "${DEST_DIR}" observe-service || exit 1
fi


echo "{\"status\": \"success\", \"message\": \"success\", \"type\": \"${type}\", \"bin_dir\": \"${DEST_DIR}\"}"
