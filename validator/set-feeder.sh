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

FEEDER_ADDRESS=$(jq </terra/voter.json -r .[0].address)

[[ "${FEEDER_ADDRESS}" =~ ^terra1 ]] || {
  echo "FEEDER_ADDRESS not found in /terra/voter.json, is feeder container configured and running"
  exit 1
}

terrad tx oracle set-feeder ${FEEDER_ADDRESS} --from=${WALLET_NAME} --fees=10000000uluna --chain-id=columbus-5
