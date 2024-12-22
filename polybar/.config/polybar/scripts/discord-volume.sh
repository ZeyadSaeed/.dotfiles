#!/bin/bash
 
# Discord SINK ID
DISCORD_ID=$(pactl list sink-inputs | grep -B 26 "Discord" | grep "Sink Input" | awk '{print $3}' | awk '{print substr($0, 2)}')
DISCORD_SINK=$(pactl list sink-inputs | grep -A 15 "Sink Input #$DISCORD_ID")
 
if [ -n "$DISCORD_ID" ]; then
    VOLUME=$(pactl list sink-inputs | grep -A 15 "Sink Input #$DISCORD_ID" | grep 'Volume' | head -n 1 | awk '{print $5}')
    MUTED=$(pactl list sink-inputs | grep -A 15 "Sink Input #$DISCORD_ID" | grep Mute | awk '{print $2}')

    if [ "$MUTED" = "yes" ] || [ "$VOLUME" = "0%" ]; then
        echo "Muted"
    else 
        echo "$VOLUME"
    fi
else
    echo "N/A"
fi
