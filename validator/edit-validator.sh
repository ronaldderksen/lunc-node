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

MONIKER=$(toml get --toml-path ${HOME}/.terra/config/config.toml moniker)

terrad tx staking edit-validator \
    --moniker="${MONIKER}" \
    --chain-id=columbus-5 \
    --from="${WALLET_NAME}" \
    --gas=auto \
    --gas-adjustment=1.4 \
    --fees=10000000uluna "$@"

    #--min-self-delegation="1" \
    #--commission-rate="${COMMISSION_RATE:-0.01}" \
