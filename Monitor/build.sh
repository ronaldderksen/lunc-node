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

../Terrad/build.sh

docker build \
  --build-arg GIT_TAG=${GIT_TAG} \
  --build-arg IMAGE_PREFIX=${IMAGE_PREFIX} \
  -t ${IMAGE_PREFIX}${TAG}:latest .
