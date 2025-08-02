#!/bin/bash

DISCORD_ID=$(pactl list sink-inputs | grep -B 26 "Discord" | grep "Sink Input" | awk '{print $3}' | awk '{print substr($0, 2)}')

if [ -n "$DISCORD_ID" ]; then
    pactl set-sink-input-volume "$DISCORD_ID" +10% 
fi
