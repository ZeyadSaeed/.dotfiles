#!/bin/bash

# Waybar keyboard layout indicator (EN / AR), updated on Hyprland layout-change events
print_layout() {
    local keymap
    keymap=${1:-$(hyprctl devices -j | jq -r '.keyboards[] | select(.main) | .active_keymap')}
    case "$keymap" in
    Arabic*) echo "AR" ;;
    *) echo "EN" ;;
    esac
}

print_layout
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    [[ $line == activelayout\>\>* ]] && print_layout "${line#*,}"
done
