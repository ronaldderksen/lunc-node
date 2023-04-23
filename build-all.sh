#! /bin/sh

for d in Base Terrad Feeder Pricerserver Monitor
do
  cd $d && ./build.sh && cd ..
done
