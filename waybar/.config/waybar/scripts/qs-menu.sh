#!/bin/bash

# Toggle a quickshell popup menu (wifi | vpn | bluetooth | agents | power), starting quickshell if needed
MENU="$1"
# Cursor x on the focused monitor, so the menu opens under the clicked button
X=$(( $(hyprctl cursorpos | cut -d, -f1) - $(hyprctl monitors -j | jq '.[] | select(.focused).x') ))

qs ipc call menu toggle "$MENU" "$X" 2>/dev/null && exit 0

setsid -f qs >/dev/null 2>&1
for _ in $(seq 30); do
    sleep 0.1
    qs ipc call menu toggle "$MENU" "$X" 2>/dev/null && exit 0
done
