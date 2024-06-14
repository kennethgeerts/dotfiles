#!/usr/bin/env python
#
# Solar
#
# Copyright 2024, Kenneth Geerts <kenneth@sofuto.be>
#
# <xbar.title>Solar</xbar.title>
# <xbar.version>v1</xbar.version>
# <xbar.author>Kenneth Geerts</xbar.author>
# <xbar.author.github>kennethgeerts</xbar.author.github>
# <xbar.desc>Solar info</xbar.desc>
# <xbar.dependencies>goodwe</xbar.dependencies>
# <xbar.abouturl>https://github.com/kennethgeerts/dotfiles/</xbar.abouturl>
# <swiftbar.runInBash>false</swiftbar.runInBash>

import asyncio
import goodwe
import os
import json

async def get_runtime_data():
    ip_address = '192.168.0.14'
    inverter = await goodwe.connect(ip_address)
    return await inverter.read_runtime_data()

ssid = os.popen("networksetup -getairportnetwork en0").read().strip()

if ssid.endswith('SofutoNET'):
    data = asyncio.run(get_runtime_data())
    # print(json.dumps(data, indent=4, sort_keys=True, default=str))

    ppv = data['ppv1']
    load = data['house_consumption']
    soc = data['battery_soc']
    day = data['e_day']
    total = data['e_total']

    # 0: "No battery"
    # 1: "Standby"
    # 2: "Discharge"
    # 3: "Charge"
    # 4: "To be charged"
    # 5: "To be discharged"
    battery_mode = data['battery_mode']
    if battery_mode == 2:
        battery_icon = ':dock.arrow.up.rectangle:'
    elif battery_mode == 3:
        battery_icon = ':dock.arrow.down.rectangle:'
    else:
        battery_icon = ':bolt.fill.batteryblock:'

    print("%.0f%% %s" % (soc, battery_icon))
    print("---")
    print(":sun.max:%.0fW – :bolt:%sW" % (ppv, load))
    print(":sun.max:%.2fkWh today – :sun.max:%.2fkWh total" % (day, total))
else:
    print('')
