#!/bin/bash

# Discord SINK ID
DISCORD_ID=$(pactl list sink-inputs | grep -B 26 "Discord" | grep "Sink Input" | awk '{print $3}' | awk '{print substr($0, 2)}')
DISCORD_SINK=$(pactl list sink-inputs | grep -A 15 "Sink Input #$DISCORD_ID")

if [ -z "$DISCORD_ID" ]; then
    echo "{\"text\":\"N/A\"}"
    exit 0
fi

VOLUME=$(pactl list sink-inputs | grep -A 15 "Sink Input #$DISCORD_ID" | grep 'Volume' | head -n 1 | awk '{print $5}')
MUTED=$(pactl list sink-inputs | grep -A 15 "Sink Input #$DISCORD_ID" | grep Mute | awk '{print $2}')
ICON=""
VOL_NUM="${VOLUME%\%}"

# Determine icon
if [[ "$MUTED" == "yes" || "$VOL_NUM" -eq 0 ]]; then
    ICON=""
elif [[ "$VOL_NUM" -lt 30 ]]; then
    ICON=""
elif [[ "$VOL_NUM" -lt 70 ]]; then
    ICON=""
else
    ICON=""
fi

echo "{\"text\":\"${ICON}  ${VOLUME}\"}"
