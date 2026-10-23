#!/bin/bash

# Waybar VPN indicator: active OpenVPN/WireGuard connection, server name in the tooltip
LINE=$(nmcli -t -f NAME,TYPE,STATE connection show --active | grep -E ':(vpn|wireguard):' | head -n 1)
if [ -z "$LINE" ]; then
    echo '{"text":"󰦞","class":"off","tooltip":"VPN: off"}'
    exit 0
fi

NAME=${LINE%%:*}
STATE=${LINE##*:}
CLASS=connected
[ "$STATE" = "activated" ] || CLASS=connecting

echo "{\"text\":\"󰦝\",\"class\":\"$CLASS\",\"tooltip\":\"$NAME\"}"
