#! /usr/bin/env bash

set -euo pipefail

trap error_handler ERR

error_handler()
{
  echo "An error occured in command $BASH_COMMAND"
}

LUNC_HOME=$(cd $(dirname $0)/..; /bin/pwd)

. ${LUNC_HOME}/env
. ${LUNC_HOME}/include/common.inc

[ "${1:-}" = "-d" ] && { ARGS="-d --restart always"; shift; } || ARGS="-it --rm"

docker &>/dev/null network inspect lunc-node || {
  docker network create --subnet=172.18.0.0/16 lunc-node
}

TAG=lunc-node-$(basename $(pwd) |tr '[A-Z]' '[a-z]')
docker &>/dev/null rm -f ${TAG} $(basename $(pwd) |tr '[A-Z]' '[a-z]')

docker run ${ARGS} \
  -v /local/terra:/terra \
  -v ${LUNC_HOME}:/home/terra/lunc-node \
  --net lunc-node \
  --name ${TAG} \
  ${TAG} "$@"
