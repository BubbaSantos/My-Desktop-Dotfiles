#!/usr/bin/env bash
# Toggle dynamic-cursors magnification on/off
STATE_FILE="/tmp/cursor-magnify-state"

SIZE=4.0
# very long duration so it effectively "stays on" until toggled off
ON_DURATION=86400000  # 24h in ms

if [[ -f "$STATE_FILE" ]]; then
    # currently ON -> turn off
    rm -f "$STATE_FILE"
    hyprctl dispatch plugin:dynamic-cursors:magnify 1 1.0
else
    # currently OFF -> turn on
    touch "$STATE_FILE"
    hyprctl dispatch plugin:dynamic-cursors:magnify "$ON_DURATION" "$SIZE"
fi
