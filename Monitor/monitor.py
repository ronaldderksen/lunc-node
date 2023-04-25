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
import shutil
import subprocess
import platform

node_name = platform.node().split(".")[0]

MULTIPLIER = 1000000
DATA_PATH = '/terra/data'

now = datetime.now()

ts = now.strftime("%Y-%m-%d %H:%M")

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
    msg2 = re.sub(r'[^\x00-\x7F]+','', node_name + ': ' + msg)
    print(msg2)
    if config['ntfy_topic']:
        requests.post("https://ntfy.sh/" + config['ntfy_topic'], data=msg2)

def validator_details(v):
    validator = terra.staking.validator(v).to_data()
    return validator

def delegator_info(delegator):
    print ( "\nDelegator: " + delegator )
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
                    "lunc/ustc": "%7.2f" % (uluna/uusd),
            }
            data_pp = {}
            data_pp['ts'] = ts
            data_pp['moniker'] = "%-20s" % re.sub(r'[^\x00-\x7F]+',' ', data['moniker'])[0:20]
            for key in ['balance','lunc','ustc','lunc/ustc']:
                data_pp[key] = data[key]
            if old:
                data_pp['lunc_diff'] = "%6.2f" % (float(data['lunc']) - float(old['lunc']))
                data_pp['ustc_diff'] = "%6.2f" % (float(data['ustc']) - float(old['ustc']))

                min_change = 1
                if float(data['lunc']) - float(old['lunc']) < min_change and float(data['lunc']) - float(old['lunc']) > 0:
                    ntfy (data['moniker'] + ": low rewards for LUNC (" + "%.4f" % (float(data['lunc']) - float(old['lunc'])) + ")")

            pp.pprint(data_pp)

            f = open(old_file, mode='w')
            f.write (json.dumps(data))
            f.close()

def validator_info(validator):
    old_file = '/tmp/'+ validator + ".json"
    try:
        old = json.loads(Path(old_file).read_text().rstrip())
    except:
        old = None
    data = validator_details(validator)
    data['lunc_tokens'] = "%d" % (int(data['tokens'])/MULTIPLIER)
    data['rate'] = "%0.2f" % float((data['commission']['commission_rates']['rate']))
    data['moniker'] = "%-20s" % re.sub(r'[^\x00-\x7F]+',' ', data['description']['moniker'])[0:20]
    data_pp = {}
    data_pp['ts'] = ts
    for key in ['moniker','jailed','status','rate','lunc_tokens']:
        data_pp[key] = data[key]
    pp.pprint(data_pp)

    min_change = 1
    if old:
        if data['rate'] != old['rate']:
            ntfy (data['moniker'] + ": rate changed to: " + data['rate'])
        if int(data['lunc_tokens']) != int(old['lunc_tokens']):
            diff = '{:,.0f}'.format(int(data['lunc_tokens'])-int(old['lunc_tokens']))
            total = '{:,.0f}'.format(int(data['lunc_tokens']))
            ntfy (data['moniker'] + ": has " + diff + " more LUNC tokens, total: " + total)

    f = open(old_file, mode='w')
    f.write (json.dumps(data))
    f.close()

def os_info():
    if os.path.isdir(DATA_PATH):
        print("\nOS")
        stat = shutil.disk_usage(DATA_PATH)

        data_pp = {}
        data_pp['ts'] = ts
        for key in ['total', 'used', 'free']:
            data_pp[key] = "%7.2f GiB" % (getattr(stat, key) / 1024 / 1024 / 1024)

        free = getattr(stat, 'free') / 1024 / 1024 / 1024
        if 'free_space_ntfy' in config and free < config['free_space_ntfy']:
            ntfy('low disk space, free space is ' + "%7.2f GiB" % free + " GiB")

        pp.pprint(data_pp)

def terrad_status():
    old_file = '/tmp/terrad-status.json'

    try:
        result = json.loads(subprocess.run(['terrad', 'status'], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL).stdout)
    except:
        result = None

    try:
        old = json.loads(Path(old_file).read_text().rstrip())
    except:
        old = None

    if old and result and 'SyncInfo' in old and 'SyncInfo' in result:
        if old['SyncInfo']['catching_up'] != result['SyncInfo']['catching_up']:
            ntfy('catching_up is now: ' + str(result['SyncInfo']['catching_up']))
        if old['SyncInfo']['latest_block_height'] == result['SyncInfo']['latest_block_height']:
            ntfy('latest_block_height is not increasing')

    if result:
        f = open(old_file, mode='w')
        f.write (json.dumps(result))
        f.close()

pp = pprint.PrettyPrinter(sort_dicts=False, width=240)

print("\nSTART: ", now.strftime('%Y-%m-%d %H:%M:%S'))

terrad_status()

for delegator in config['delegators']:
    delegator_info(delegator)

print("\nValidators")
for validator in config['validators']:
    validator_info(validator)

os_info()
