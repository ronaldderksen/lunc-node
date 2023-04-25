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

TAG=lunc-node-$(basename $(dirname $(realpath $0)) |tr '[A-Z]' '[a-z]')
docker &>/dev/null rm -f ${TAG} $(basename $(pwd) |tr '[A-Z]' '[a-z]')

docker run ${ARGS} \
  -v /local/terra:/terra \
  -v ${LUNC_HOME}:/home/terra/lunc-node \
  -e TERRAVALOPER="${TERRAVALOPER:-}" \
  -e ORACLE_FEEDER_MNENOMIC="${ORACLE_FEEDER_MNENOMIC:-}" \
  -e ORACLE_FEEDER_PASSWORD="${ORACLE_FEEDER_PASSWORD:-}" \
  -e ORACLE_FEEDER_VALIDATORS="${ORACLE_FEEDER_VALIDATORS:-}" \
  -e ORACLE_FEEDER_IV_SALT="${ORACLE_FEEDER_IV_SALT:-Qp42jxz}" \
  --net host \
  --name ${TAG} \
  ${DOCKER_ARGS:-} \
  ${TAG} "$@"

  #-e VALIDATOR_ADDRESS="${VALIDATOR_ADDRESS:-}" \
  #-e ORACLE_FEEDER_COIN_TYPE=330 \
  #-e COIN_TYPE=330 \
