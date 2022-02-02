SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

DEST_DIR="$1"
OS="$2"
CLI_NAME="rosa"

FILENAME="rosa-linux.tar.gz"
if [[ "${OS}" == "macos" ]]; then
  FILENAME="rosa-macosx.tar.gz"
fi

URL="https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/${FILENAME}"

"${SCRIPT_DIR}/setup-binary.sh" "${DEST_DIR}" rosa "${URL}"
