#! /bin/sh

mkdir -p ${HOME}/log
(
  cd ${HOME}/git/oracle-feeder/price-server || exit
  while :
  do
    npm start
    sleep 10
  done
) 2>&1 | tee ${HOME}/log/price-server.log
