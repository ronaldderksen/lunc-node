#! /usr/bin/env bash

set -euo pipefail

trap error_handler ERR

error_handler()
{
  echo "An error occured in command $BASH_COMMAND"
}

LUNC_HOME=$(cd $(dirname $0)/..; /bin/pwd)

. ${LUNC_HOME}/include/common.inc

[ "${1:-}" = "-d" ] && { ARGS="-d --restart always"; shift; } || ARGS="-it --rm"

TAG=lunc-node-$(basename $(pwd) |tr '[A-Z]' '[a-z]')
docker &>/dev/null rm -f ${TAG} $(basename $(pwd) |tr '[A-Z]' '[a-z]')

docker run ${ARGS} \
  -v /local/terra:/terra \
  -v ${LUNC_HOME}:/home/terra/lunc-node \
  -e MONIKER="${MONIKER:-}" \
  -e P2P_PORT="${P2P_PORT}" \
  -e API_PORT="${API_PORT}" \
  --net host \
  --name ${TAG} \
  -p ${P2P_PORT}:${P2P_PORT} \
  -p 1317:1317 \
  ${DOCKER_ARGS:-} \
  ${TAG} "$@"
