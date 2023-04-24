P2P_PORT=${P2P_PORT:-26656}
API_PORT=${API_PORT:-1317}

# Find env file
if [ -e "${HOME}/.terra/config/env" ]; then
  . ${HOME}/.terra/config/env
elif [ -e "/local/terra/config/env" ]; then
  . /local/terra/config/env
elif [ -e "${LUNC_HOME}/env" ]; then
  . ${LUNC_HOME}/env
else
  echo "Cannot find env file"
  exit 1
fi
