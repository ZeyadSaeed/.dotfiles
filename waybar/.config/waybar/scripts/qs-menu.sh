#!/bin/bash

# Toggle a quickshell popup menu (wifi | bluetooth | power), starting quickshell if needed
MENU="$1"

qs ipc call menu toggle "$MENU" 2>/dev/null && exit 0

setsid -f qs >/dev/null 2>&1
for _ in $(seq 30); do
    sleep 0.1
    qs ipc call menu toggle "$MENU" 2>/dev/null && exit 0
done
