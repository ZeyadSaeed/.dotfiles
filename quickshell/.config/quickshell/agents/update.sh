#!/bin/bash

# Regenerate agent usage records into ~/.local/state/agent-usage/<agent>.json.
# The quickshell agents panel watches these files; waybar reads them for the bar icon.
DIR="$(dirname "$(readlink -f "$0")")"
OUT="${XDG_STATE_HOME:-$HOME/.local/state}/agent-usage"
mkdir -p "$OUT"

# Only one update at a time
exec 9>"$OUT/.lock"
flock -n 9 || exit 0

collect() {
    local agent="$1" record tmp
    command -v "$agent" >/dev/null || return 0
    record=$(timeout 60 "$DIR/usage-$agent" "${@:2}") || return 1
    jq -e . >/dev/null 2>&1 <<<"$record" || return 1
    tmp=$(mktemp "$OUT/.$agent.XXXXXX")
    printf '%s\n' "$record" >"$tmp"
    mv "$tmp" "$OUT/$agent.json"
}

collect claude "$@" &
collect codex "$@" &
wait
