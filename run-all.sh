#! /bin/sh

for d in Terrad Feeder Priceserver Monitor
do
  $d/run.sh -d
done
