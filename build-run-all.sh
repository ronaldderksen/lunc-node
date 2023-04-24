#! /bin/sh

for d in Terrad Feeder Priceserver Monitor
do
  cd $d && ./build.sh && ./run.sh -d && cd ..
done
