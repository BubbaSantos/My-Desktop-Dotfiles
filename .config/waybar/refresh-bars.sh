#!/bin/bash
# ~/.config/waybar/refresh-bars.sh

#notify-send "Reloading" "Killing processes..."

pkill -9 -f "cava.sh" 2>/dev/null
pkill -9 cava 2>/dev/null
killall -9 waybar  # Use killall with exact name
sleep 0.3

#notify-send "Reloading" "Starting bars..."

setsid waybar -c ~/.config/waybar/config-main.jsonc &
sleep 0.5
setsid waybar -c ~/.config/waybar/config-secondary.jsonc &

#notify-send "Reloading" "Done!"
