export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1" 
TYPE="$2"
ARCH_BASE="$3"


CLI_NAME="rclone"

FILENAME="rclone-v1.60.1-linux-${ARCH}.zip"

#arc for rclone binaries - arm64 and amd64
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="rclone-v1.60.1_macOS_${ARCH}.zip"
fi


#URL="https://mirror.openshift.com/pub/openshift-v4/${ARCH}/clients/rosa/latest/${FILENAME}"
URL="https://downloads.rclone.org/v1.60.1/${FILENAME}"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${CLI_NAME}" version

