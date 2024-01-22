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

CONTAINERS2RUN=${CONTAINERS2RUN:-Terrad Feeder Priceserver Monitor}
P2P_PORT=${P2P_PORT:-26656}
API_PORT=${API_PORT:-1317}
GIT_TAG=${GIT_TAG:-v2.3.2}
IMAGE_PREFIX=${IMAGE_PREFIX:-ronaldd/}
