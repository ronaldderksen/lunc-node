#! /bin/sh

export ORACLE_FEEDER_CHAIN_ID=columbus-5
export ORACLE_FEEDER_KEY_NAME=voter
export ORACLE_FEEDER_KEY_PATH=voter.json
export ORACLE_FEEDER_COIN_TYPE=330
export ORACLE_FEEDER_ADDR_PREFIX="terra"

mkdir -p ${HOME}/log

if [ -n "${ORACLE_FEEDER_MNENOMIC:-} -a -n "${ORACLE_FEEDER_PASSWORD:-} ]; then
  cd ${HOME}/git/oracle-feeder/feeder || exit
  # create fresh votor.json
  echo '[]' >voter.json
  npm start add-key
fi

if [ "$(jq <${HOME}/git/oracle-feeder/feeder/voter.json -r .[0].name)" = ${ORACLE_FEEDER_KEY_NAME} -a -n "${ORACLE_FEEDER_VALIDATORS}" -a -n "${ORACLE_FEEDER_PASSWORD}" ]; then
  (
    cd ${HOME}/git/oracle-feeder/feeder || exit
    while :
    do
      npm start vote -- \
        -d http://127.0.0.1:8532/latest \
        --lcd-url http://127.0.1.1:1317 \
        --chain-id columbus-5 \
	  --validators ${ORACLE_FEEDER_VALIDATORS} \
        -p "${ORACLE_FEEDER_PASSWORD}"
      sleep 10
    done
  ) 2>&1 | tee ${HOME}/log/feeder.log
else
  echo "Not all requirmentes are met to start feeder"
fi
