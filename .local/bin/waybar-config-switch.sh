#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
MAIN="$WAYBAR_DIR/config-main.jsonc"
COMPACT="$WAYBAR_DIR/config-main-compact.jsonc"
STATE_FILE="/tmp/waybar-config-state"

if [[ -f "$STATE_FILE" && "$(cat "$STATE_FILE")" == "compact" ]]; then
    CONFIG="$MAIN"
    echo "main" > "$STATE_FILE"
else
    CONFIG="$COMPACT"
    echo "compact" > "$STATE_FILE"
fi

pkill waybar
sleep 0.3
nohup waybar --config "$CONFIG" > /dev/null 2>&1 &
