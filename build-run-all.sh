#! /bin/sh

for d in Terrad Feeder Priceserver Monitor
do
  $d/build.sh && $d/run.sh -d
done
