#!/usr/bin/env python3

import asyncio
import goodwe
import json
import os

async def get_runtime_data():
    ip_address = '192.168.0.151'
    inverter = await goodwe.connect(ip_address)
    return await inverter.read_runtime_data()

data = asyncio.run(get_runtime_data())
print(json.dumps(data, default=str))

# data['battery_mode']
#   0: "No battery"
#   1: "Standby"
#   2: "Discharge"
#   3: "Charge"
#   4: "To be charged"
#   5: "To be discharged"
