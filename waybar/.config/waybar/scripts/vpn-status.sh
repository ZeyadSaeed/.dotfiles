#!/bin/bash

# Waybar VPN indicator: active OpenVPN/WireGuard connection, country code from the proton-<cc>-<n> name
LINE=$(nmcli -t -f NAME,TYPE,STATE connection show --active | grep -E ':(vpn|wireguard):' | head -n 1)
if [ -z "$LINE" ]; then
    echo '{"text":"󰦞","class":"off","tooltip":"VPN: off"}'
    exit 0
fi

NAME=${LINE%%:*}
STATE=${LINE##*:}
CC=$(echo "$NAME" | sed -nE 's/^proton-([a-z]+).*/\1/p' | tr a-z A-Z)
CLASS=connected
[ "$STATE" = "activated" ] || CLASS=connecting

echo "{\"text\":\"󰦝 ${CC:-VPN}\",\"class\":\"$CLASS\",\"tooltip\":\"$NAME\"}"
