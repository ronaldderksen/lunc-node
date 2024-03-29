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

docker pull ${IMAGE_PREFIX}${TAG}:${GIT_TAG}
