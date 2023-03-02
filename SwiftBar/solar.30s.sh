#!/usr/bin/env python3

import asyncio
import goodwe
import os

async def get_runtime_data():
    ip_address = '192.168.0.14'
    inverter = await goodwe.connect(ip_address)
    return await inverter.read_runtime_data()

ssid = os.popen("/Sy*/L*/Priv*/Apple8*/V*/C*/R*/airport -I | awk '/ SSID:/ {print $2}'").read().strip()

if ssid == 'SofutoNET':
    data = asyncio.run(get_runtime_data())
    ppv = data['ppv1']
    load = data['house_consumption']
    soc = data['battery_soc']
    day = data['e_day']
    total = data['e_total']

    print(":sun.max:%.0fW :bolt:%sW :bolt.fill.batteryblock:%.0f%% | size = 11" % (ppv, load, soc))
    print("---")
    print("Day: %.2fkWh" % day)
    print("Total: %.2fkWh" % total)
else:
    print('')
