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

docker build \
  --build-arg P2P_PORT=${P2P_PORT} \
  --build-arg API_PORT=${API_PORT} \
  -t lunc-node .
