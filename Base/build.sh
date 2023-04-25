#! /usr/bin/env bash

set -euo pipefail

trap error_handler ERR

error_handler()
{
  echo "An error occured in command $BASH_COMMAND"
}

LUNC_HOME=$(cd $(dirname $0)/..; /bin/pwd)

. ${LUNC_HOME}/include/common.inc

TAG=lunc-node-$(basename $(dirname $(realpath $0)) |tr '[A-Z]' '[a-z]')

cd $(dirname $0)

docker build -t ${TAG} \
  --build-arg TERRA_UID=${TERRA_UID:-$(id -u)} \
  --build-arg TERRA_GID=${TERRA_GID:-$(id -g)} \
  ${LUNC_HOME}/Base
