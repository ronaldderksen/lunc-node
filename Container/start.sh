#! /bin/sh

mkdir -p $HOME/log
if [ -n "${VOTER_PASSWORD:-}" -a -n "${VALIDATOR_ADDRESS:-}" ]; then
  (
    cd $HOME/git/oracle-feeder/price-server || exit
    while :
    do
      npm start
      sleep 10
    done
  ) &>$HOME/log/price-server.log &

  (
    cd $HOME/git/oracle-feeder/feeder || exit
    while :
    do
      npm start vote -- \
        -d http://localhost:8532/latest \
        --lcd-url http://localhost:1317 \
        --chain-id columbus-5 \
        --validators ${VALIDATOR_ADDRESS} \
        -p "${VOTER_PASSWORD}"
      sleep 10
    done
  ) &>$HOME/log/feeder.log &
fi
  
terrad start
