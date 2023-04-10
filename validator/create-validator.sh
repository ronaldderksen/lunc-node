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

terrad tx staking create-validator \
    --amount=1000000000uluna \
    --pubkey=$(terrad tendermint show-validator) \
    --moniker="${MONIKER}" \
    --chain-id=columbus-5 \
    --commission-rate="${COMMISSION_RATE:-0.01}" \
    --commission-max-rate="${COMMISSION_MAX_RATE:-0.08}" \
    --commission-max-change-rate="${COMMISSION_MAX_CHANGE_RATE:-0.01}" \
    --from="${WALLET_NAME}" \
    --min-self-delegation="1" \
    --gas=auto \
    --gas-adjustment=1.4 \
    --fees=1500000uluna
