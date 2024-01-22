#! /bin/sh

LUNC_HOME=$(cd $(dirname $0); /bin/pwd)

. ${LUNC_HOME}/include/common.inc

for d in ${CONTAINERS2RUN}
do
  $d/run.sh -d
done
