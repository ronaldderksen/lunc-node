#! /bin/sh

for d in Terrad Feeder Priceserver Monitor
do
  $d/pull.sh -d
done
