#!/bin/bash

PID_FILE="/tmp/lowfi.pid"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo '{"text": "󰝚"}'
else
    echo '{"text": "󰝛"}'
fi
