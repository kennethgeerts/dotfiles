#!/bin/sh

API="https://api.openweathermap.org/data/2.5"
KEY="e434b5435a979de6e155570590bee89b"
CITY="Merendree"
UNITS="metric"
SYMBOL="°"

if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
    CITY_PARAM="id=$CITY"
else
    CITY_PARAM="q=$CITY"
fi

weather=$(curl -sf "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
if [ -n "$weather" ]; then
    temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
    echo "$temp$SYMBOL"
fi
