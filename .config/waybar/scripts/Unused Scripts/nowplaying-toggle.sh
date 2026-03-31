#!/bin/bash
# ~/.config/waybar/scripts/nowplaying-toggle.sh
STATE_FILE="/tmp/waybar_nowplaying_hidden"

if [ -f "$STATE_FILE" ]; then
  rm "$STATE_FILE"
else
  touch "$STATE_FILE"
fi

# Trigger Waybar update
pkill -RTMIN+8 waybar
