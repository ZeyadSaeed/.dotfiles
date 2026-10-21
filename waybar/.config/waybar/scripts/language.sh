#!/bin/bash

# Waybar keyboard layout indicator (EN / AR), updated on Hyprland layout-change events
# Always read the main keyboard: every device fires activelayout, so the event payload may be a headset or mic
print_layout() {
    local keymap
    keymap=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main) | .active_keymap')
    case "$keymap" in
    Arabic*) echo "AR" ;;
    *) echo "EN" ;;
    esac
}

print_layout
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    [[ $line == activelayout\>\>* ]] && print_layout
done
