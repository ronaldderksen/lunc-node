#! /usr/bin/env python3.9

import requests
import json
import os

gas_price_dict = requests.get("https://fcd.terra.dev/v1/txs/gas_prices").json()

res = ''
for key in gas_price_dict:
    if res == '':
        res = gas_price_dict[key] + key
    else:
        res += "," + gas_price_dict[key] + key

print (res)
