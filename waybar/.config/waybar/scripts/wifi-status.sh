#!/bin/bash

# Waybar wifi indicator: slashed icon when the radio is off, outline when on but not connected
if [ "$(nmcli radio wifi)" != "enabled" ]; then
    echo '{"text":"󰤮","class":"off","tooltip":"Wi-Fi: off"}'
    exit 0
fi

LINE=$(nmcli -t -f ACTIVE,SIGNAL,SSID dev wifi list --rescan no | grep '^yes:' | head -n 1)
if [ -z "$LINE" ]; then
    echo '{"text":"󰤯","class":"disconnected","tooltip":"Wi-Fi: not connected"}'
    exit 0
fi

SIGNAL=$(echo "$LINE" | cut -d: -f2)
SSID=$(echo "$LINE" | cut -d: -f3- | sed 's/\\:/:/g; s/"/\\"/g')
ICONS=("󰤟" "󰤢" "󰤥" "󰤨")
IDX=$((SIGNAL / 26))
[ "$IDX" -gt 3 ] && IDX=3

echo "{\"text\":\"${ICONS[$IDX]}\",\"class\":\"connected\",\"tooltip\":\"${SSID}  ${SIGNAL}%\"}"
