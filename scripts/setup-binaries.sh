#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

INPUT=$(tee)

function debug() {
  echo "${SCRIPT_DIR}: (all) $1" >> clis-debug.log
}

debug "Input: ${INPUT}"

DEST_DIR=$(echo "${INPUT}" | grep bin_dir | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')
CLIS=$(echo "${INPUT}" | grep clis | sed -E 's/.*"clis": ?"([^"]*)".*/\1/g')
export UUID=$(echo "${INPUT}" | grep uuid | sed -E 's/.*"uuid": ?"([^"]*)".*/\1/g')

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

ARCH=""
case $(uname -m) in
    i386)    ARCH="386" ;;
    i686)    ARCH="386" ;;
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    arm64)   ARCH="arm64" ;;
    armv7l)  ARCH="arm" ;;
    arm)     ARCH="arm" ;;
    *)       echo "Unable to determine system architecture" >&2; exit 1 ;;
esac
debug "Detected architecture: ${ARCH}"

mkdir -p "${DEST_DIR}" || exit 1

"${SCRIPT_DIR}/setup-jq.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1

if [[ "${CLIS}" =~ igc ]]; then
  "${SCRIPT_DIR}/setup-igc.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ yq ]]; then
  "${SCRIPT_DIR}/setup-yq3.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
  "${SCRIPT_DIR}/setup-yq4.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ helm ]]; then
  "${SCRIPT_DIR}/setup-helm.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ argocd ]]; then
  "${SCRIPT_DIR}/setup-argocd.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ rosa ]]; then
  "${SCRIPT_DIR}/setup-rosa.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ gh ]]; then
  "${SCRIPT_DIR}/setup-gh.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ glab ]]; then
  "${SCRIPT_DIR}/setup-glab.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ kubeseal ]]; then
  "${SCRIPT_DIR}/setup-kubeseal.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ oc ]] || [[ "${CLIS}" =~ kubectl ]]; then
  "${SCRIPT_DIR}/setup-oc.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ kustomize ]]; then
  "${SCRIPT_DIR}/setup-kustomize.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud-is ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud-plugin.sh" "${DEST_DIR}" infrastructure-service || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud-ob ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud-plugin.sh" "${DEST_DIR}" observe-service || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud-ks ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud-plugin.sh" "${DEST_DIR}" kubernetes-service || exit 1
fi

if [[ "${CLIS}" =~ ibmcloud-cr ]]; then
  "${SCRIPT_DIR}/setup-ibmcloud-plugin.sh" "${DEST_DIR}" container-registry || exit 1
fi

if [[ "${CLIS}" =~ gitu ]]; then
  "${SCRIPT_DIR}/setup-gitu.sh" "${DEST_DIR}" "${TYPE}" || exit 1
fi

if [[ "${CLIS}" =~ openshift-install ]]; then
  VERSION=$(echo "${CLIS}" | sed -E 's/.*openshift-install-?([0-9]*[.]*[0-9]*[.]*[0-9]*).*/\1/g')
  "${SCRIPT_DIR}/setup-openshift-install.sh" "${DEST_DIR}" "${TYPE}" "${ARCH}" "${VERSION}" || exit 1
fi

OUTPUT="{\"status\": \"success\", \"message\": \"success\", \"type\": \"${type}\", \"bin_dir\": \"${DEST_DIR}\"}"

debug "Completed: ${OUTPUT}"

echo "${OUTPUT}"
