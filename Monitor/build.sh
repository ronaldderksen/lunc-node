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

TAG=lunc-node-$(basename $(pwd) |tr '[A-Z]' '[a-z]')

docker build -t lunc-node-base ../Base
docker build \
  -t ${TAG} .
