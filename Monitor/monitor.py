#! /usr/bin/env python3.9

from terra_sdk.client.lcd import LCDClient
from terra_sdk.key.mnemonic import MnemonicKey
from terra_sdk.client.lcd.api.tx import CreateTxOptions, SignerOptions
from terra_sdk.core.bank import MsgSend
from terra_sdk.core.staking import MsgDelegate
from terra_sdk.core.fee import Fee
from terra_sdk.core.distribution import MsgWithdrawDelegatorReward
from pathlib import Path
from datetime import datetime

import requests
import json
import yaml
import os
import re
import math
import time
import pprint

MULTIPLIER = 1000000

wd = os.path.dirname(__file__)
if os.path.isfile(wd + '/config.yaml'):
    config = yaml.safe_load(Path(wd + '/config.yaml').read_text())
else:
    config = yaml.safe_load(Path('/usr/local/etc/config.yaml').read_text())

if 'lcd_url' in config:
    lcd_url = config['lcd_url']
else:
    lcd_url = 'https://terra-classic-lcd.publicnode.com'

terra = LCDClient(chain_id="columbus-5", url=lcd_url)

def ntfy(msg):
    print(msg)
    if config['ntfy_topic']:
        requests.post("https://ntfy.sh/" + config['ntfy_topic'], data=msg)

def validator_details(v):
    validator = terra.staking.validator(v).to_data()
    return validator

def delegator_info(delegator):
    print ( 'Delegator: ' + delegator )
    rewards = terra.distribution.rewards(delegator)
    delegations = terra.staking.delegations(delegator=delegator)
    for x in delegations[0]:
        validator_address = x.delegation.validator_address
        validator = validator_details(validator_address)
        coins = rewards.rewards[validator_address]
        old_file = '/tmp/'+ delegator + '-' + validator_address + ".json"
        try:
            uluna = int(coins.get("uluna").amount)
            uusd = int(coins.get("uusd").amount)
            balance = x.balance.amount
        except:
            uluna = 0
        if uluna > 1:
            try:
                old = json.loads(Path(old_file).read_text().rstrip())
            except:
                old = None

            data = {
                    "validator_address": validator_address,
                    "moniker": validator['description']['moniker'],
                    "balance": "%12.2f" % (balance/MULTIPLIER),
                    "lunc": "%8.2f" % (uluna/MULTIPLIER),
                    "ustc": "%9.4f" % (uusd/MULTIPLIER),
                    "div": "%7.2f" % (uluna/uusd),
            }
            data_pp = {}
            data_pp['moniker'] = "%-40s" % re.sub(r'[^\x00-\x7F]+',' ', data['moniker'])[0:40]
            for key in ['balance','lunc','ustc','div']:
                data_pp[key] = data[key]
            pp.pprint(data_pp)

            min_change = 1
            if old and float(data['lunc']) - float(old['lunc']) < min_change and float(data['lunc']) - float(old['lunc']) > 0:
                ntfy (data['moniker'] + ": low rewards for LUNC")

            f = open(old_file, mode='w')
            f.write (json.dumps(data))
            f.close()

pp = pprint.PrettyPrinter(sort_dicts=False, width=240)

print("\nSTART: ", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

for delegator in config['delegators']:
    delegator_info(delegator)
