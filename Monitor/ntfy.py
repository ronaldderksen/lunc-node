#! /usr/bin/env python3.9

from pathlib import Path
from datetime import datetime

import requests
import yaml
import os
import sys

MULTIPLIER = 1000000

wd = os.path.dirname(__file__)
if os.path.isfile(wd + '/config.yaml'):
    config = yaml.safe_load(Path(wd + '/config.yaml').read_text())
else:
    config = yaml.safe_load(Path('/usr/local/etc/config.yaml').read_text())

def ntfy(msg):
    print(msg)
    if config['ntfy_topic']:
        requests.post("https://ntfy.sh/" + config['ntfy_topic'], data=msg)

ntfy(sys.argv[1])
