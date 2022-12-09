export SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1" 
TYPE="$2"
ARCH_BASE="$3"


CLI_NAME="rclone"

FILENAME="rclone-v1.60.1-linux-${ARCH_BASE}"

#arc for rclone binaries - arm64 and amd64
if [[ "${TYPE}" == "macos" ]]; then
  FILENAME="rclone-v1.60.1-osx-${ARCH_BASE}"
  
fi

URL="https://downloads.rclone.org/v1.60.1/${FILENAME}.zip"

"${SCRIPT_DIR}/setup-binary-from-tgz.sh" "${DEST_DIR}" "${CLI_NAME}" "${URL}" "${FILENAME}" version
