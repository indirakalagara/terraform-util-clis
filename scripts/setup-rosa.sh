SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
DEST_DIR="$1" 
TYPE="$2"
CLI_NAME="rosa"

mkdir -p "${DEST_DIR}"
BIN_DIR=$(cd "${DEST_DIR}"; pwd -P)

#TGZ_PATH="${DEST_DIR}/rosa"
#mkdir -p $TGZ_PATH


FILENAME="rosa-linux.tar.gz"
# TGZ_PATH="linux-amd64/rosa"  
if [[ "$TYPE" == "macos" ]]; then
  FILENAME="rosa-macosx.tar.gz"
  #TGZ_PATH="darwin-amd64/rosa"    
fi

CLI_URL="https://mirror.openshift.com/pub/openshift-v4/clients/rosa/latest/${FILENAME}"

if command -v "${BIN_DIR}/${CLI_NAME}" 1> /dev/null 2> /dev/null; then
  exit 0
fi

COMMAND=$(command -v "${CLI_NAME}")

if [[ -n "${COMMAND}" ]]; then
  ln -s "${COMMAND}" "${BIN_DIR}/${CLI_NAME}"
  COMMAND="${BIN_DIR}/${CLI_NAME}"
else
  TAR_FILE="${BIN_DIR}/${CLI_NAME}.tgz"
  if [[ -f "${TAR_FILE}" ]]; then
    while [[ -f "${TAR_FILE}" ]]; do
      sleep 10
    done
  else
    touch "${TAR_FILE}"

    curl -sLo "${TAR_FILE}" "${CLI_URL}"
    
    if [[ ! -f "${BIN_DIR}/${CLI_NAME}" ]]; then
      tar xzf "${TAR_FILE}"
      
      cp "${CLI_NAME}" "${BIN_DIR}/${CLI_NAME}"
    fi

    rm "${TAR_FILE}"
    chmod +x "${BIN_DIR}/${CLI_NAME}"
  fi

  COMMAND="${BIN_DIR}/${CLI_NAME}"
fi
