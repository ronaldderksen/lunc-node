#! /bin/sh

for d in Terrad Feeder Priceserver Monitor
do
  cd $d && ./build.sh && cd ..
done
