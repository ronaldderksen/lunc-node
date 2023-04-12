#! /bin/sh

crond

echo "Sleep" >/proc/1/fd/1 

exec sleep 3600
