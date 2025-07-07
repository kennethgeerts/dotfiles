#!/bin/bash

PID_FILE="/tmp/lowfi.pid"
REFRESH_FILE="/tmp/lowfi-refresh"

is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

start_lowfi() {
    setsid lowfi </dev/null >/dev/null 2>&1 &
    echo $! > "$PID_FILE"
}

stop_lowfi() {
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
}

if is_running; then
    stop_lowfi
else
    start_lowfi
fi

# Touch refresh file to trigger Waybar update
touch "$REFRESH_FILE"

