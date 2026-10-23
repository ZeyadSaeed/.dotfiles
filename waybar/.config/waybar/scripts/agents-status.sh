#!/bin/bash

# Waybar agents icon: refreshes usage records, shows the highest rate-limit usage across agents
~/.config/quickshell/agents/update.sh

DIR="${XDG_STATE_HOME:-$HOME/.local/state}/agent-usage"
shopt -s nullglob
FILES=("$DIR"/*.json)
[ ${#FILES[@]} -eq 0 ] && { echo '{"text":"󰚩","tooltip":"No agent usage yet"}'; exit 0; }

jq -sc '
  [.[] | {name, limits: (.limits // [])}] as $agents
  | ([$agents[].limits[].percent] | max // 0) as $max
  | {
      text: "󰚩",
      class: (if $max >= 0.9 then "critical" elif $max >= 0.7 then "warning" else "normal" end),
      tooltip: ([$agents[] | "\(.name): " + ([.limits[] | "\(.label) \(.percent * 100 | round)%"] | join(", "))] | join("\n"))
    }
' "${FILES[@]}"
