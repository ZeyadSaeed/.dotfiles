#!/bin/bash

# tokyo-night-tmux hardcodes Nerd Font icons (session/prefix, tab/ssh, last window); drop those blocks from its formats
for opt in status-left window-status-format window-status-current-format; do
    tmux set -g "$opt" "$(tmux show -gv "$opt" | sed \
        -e 's/#{?client_prefix,[^}]*}//' \
        -e 's/#{?#{==:#{pane_current_command},ssh},[^}]*}//' \
        -e 's/#{?window_last_flag,[^}]*}/ /')"
done
