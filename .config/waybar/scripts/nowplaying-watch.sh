#!/bin/bash
# ~/.config/waybar/scripts/nowplaying-watch.sh
playerctl -a metadata --follow --format '{{playerName}} {{status}}' 2>/dev/null | while read -r line; do
    pkill -RTMIN+8 waybar
    sleep 0.5
    pkill -RTMIN+8 waybar
done
