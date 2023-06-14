#! /bin/sh

for d in Terrad Feeder Priceserver Monitor
do
  $d/push.sh -d
done
