#!/usr/bin/env python3

import asyncio
import goodwe

async def get_runtime_data():
    ip_address = '192.168.0.14'
    inverter = await goodwe.connect(ip_address)
    return await inverter.read_runtime_data()

data = asyncio.run(get_runtime_data())
ppv = data['ppv']
load = data['house_consumption']
soc = data['battery_soc']
day = data['e_day']
total = data['e_total']

print(":sun.max:%.0fW :bolt:%sW :bolt.fill.batteryblock:%.0f%% | size = 11" % (ppv, load, soc))
print("---")
print("Day: %.2fkWh" % day)
print("Total: %.2fkWh" % total)
