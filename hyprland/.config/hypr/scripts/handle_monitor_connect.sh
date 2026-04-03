#!/bin/sh

#
#handle() {
#    case $1 in monitoradded*)
#        hyprctl dispatch moveworkspacetomonitor "1 1"
#        hyprctl dispatch moveworkspacetomonitor "2 1"
#        ;;
#    esac
#}
#
#socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done

handle() {
    case $1 in
    monitoradded*)
        # Extract the content after ">>"
        MONITOR=${1#*>>}

        # Move workspaces to the NEWLY added monitor
        hyprctl dispatch moveworkspacetomonitor "1 $MONITOR"
        hyprctl dispatch moveworkspacetomonitor "2 $MONITOR"
        ;;
    esac
}

# Ensure the socket path is correct
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
