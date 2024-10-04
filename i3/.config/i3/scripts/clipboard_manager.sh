#!/bin/bash

selection=$(greenclip print | rofi -dmenu -p "Clipboard")

echo "Selected: $selection"

if [ -n "$selection" ]; then
    echo $selection | xclip -selection clipboard 
    xdotool key ctrl+v
fi
