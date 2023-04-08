#! /usr/bin/env bash

set -euo pipefail

trap error_handler ERR

error_handler()
{
  echo "An error occured in command $BASH_COMMAND"
}

trap "rm -rf ${HOME}/.terra/tmp" EXIT

cd ${HOME}

TERRA_TMP=${HOME}/.terra/tmp
[ ! -d ${HOME}/.terra/tmp ] && mkdir ${HOME}/.terra/tmp

download()
{
  curl -o ${TERRA_TMP}/download ${2} && mv ${TERRA_TMP}/download ${1} || { rm -f ${TERRA_TMP}/download ; false ; }
}

default()
{
  testfile=${HOME}/.terra/config/.d/${1}-${2}-${3}
  tomlfile=${HOME}/.terra/config/${1}
  [ -e ${testfile} ] && return
  [ ! -d $(dirname ${testfile}) ] && mkdir $(dirname ${testfile})
  echo "Set default: $@"
  toml set --toml-path ${tomlfile} "${2}" "${3}" && touch $testfile
}

[ ! -d ${HOME}/.terra/config ] && mkdir ${HOME}/.terra/config
[ ! -e ${HOME}/.terra/config/genesis.json ] && download ${HOME}/.terra/config/genesis.json ${GENESIS_URL:-https://www.terrarebels.net/assets/genesis.json}
[ ! -e ${HOME}/.terra/config/addrbook.json ] && download ${HOME}/.terra/config/addrbook.json ${ADDRBOOK_URL:-https://dl2.quicksync.io/json/addrbook.terra.json}
[ ! -e ${HOME}/.terra/config/client.toml ] && rm -f ${HOME}/.terra/config/.d/client.toml-*
[ ! -e ${HOME}/.terra/config/app.toml ] && rm -f ${HOME}/.terra/config/.d/app.toml-*

# This wil create missing config files
terrad status &>/dev/null || true

# Apply some defaults
default client.toml chain-id columbus-5
default app.toml api.enable true

# env settings
EXTERNAL_IP=${EXTERNAL_IP:-$(curl -q 2>/dev/null ipinfo.io/ip)}
P2P_PORT=${P2P_PORT:-26656}
[ -n "${MONIKER:-}" ] && toml set --toml-path ${HOME}/.terra/config/config.toml moniker ${MONIKER}
[ -n "${P2P_PORT:-}" ] && toml set --toml-path ${HOME}/.terra/config/config.toml p2p.laddr "tcp://0.0.0.0:${P2P_PORT}"
[ -n "${API_PORT:-}" ] && toml set --toml-path ${HOME}/.terra/config/app.toml api.address "tcp://0.0.0.0:${API_PORT}"
[ -n "${EXTERNAL_IP:-}" -a -n ${P2P_PORT:-} ] && toml set --toml-path ${HOME}/.terra/config/config.toml p2p.external_address ${EXTERNAL_IP}:${P2P_PORT}

if [ ! -d ${HOME}/.terra/data/state.db ]; then
  cd ${TERRA_TMP}
  URL=`curl -s -L https://quicksync.io/terra.json|jq -r '.[] |select(.file=="columbus-5-pruned")|select (.mirror=="Netherlands")|.url'`
  curl -s ${URL} |lz4 -d |tar xvf -
  rm -rf ${HOME}/.terra/data
  mv data ${HOME}/.terra/data
fi

exec "$@"
