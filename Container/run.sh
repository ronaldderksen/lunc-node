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

docker &>/dev/null rm -f lunc-node

docker run ${ARGS} \
  -v /local/terra:/terra \
  -e MONIKER="${MONIKER:-}" \
  -e P2P_PORT="${P2P_PORT}" \
  -e API_PORT="${API_PORT}" \
  -e VOTER_PASSWORD="${VOTER_PASSWORD:-}" \
  -e VALIDATOR_ADDRESS="${VALIDATOR_ADDRESS:-}" \
  -e ORACLE_FEEDER_COIN_TYPE=330 \
  --name lunc-node \
  -p ${P2P_PORT}:${P2P_PORT} \
  -p 1317:1317 \
  ${DOCKER_ARGS:-} \
  lunc-node "$@"
