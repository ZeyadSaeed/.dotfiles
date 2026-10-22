#!/bin/bash

set -o pipefail

# Pick a clipboard history entry and paste it into the focused window (like Windows Win+V)
cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy || exit 0

# Terminals paste text with Ctrl+Shift+V, everything else with Ctrl+V.
# Images always use Ctrl+V: TUI apps like Claude Code read clipboard images on Ctrl+V themselves
MODS=CTRL
[ "$(hyprctl activewindow -j | jq -r .class)" = "com.mitchellh.ghostty" ] && ! wl-paste --list-types | grep -q '^image/' && MODS="CTRL SHIFT"
hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"$MODS\", key = \"V\" })"
