#!/bin/bash
# ~/.config/waybar/reload-waybar.sh

notify-send "Reloading Waybar" "Killing processes..."

pkill -9 -f "cava.sh"
pkill -9 cava
pkill waybar
sleep 0.3

notify-send "Reloading Waybar" "Starting waybar..."

setsid waybar -c ~/.config/waybar/config-main.jsonc &
sleep 0.5
setsid waybar -c ~/.config/waybar/config-secondary.jsonc &

notify-send "Reloading Waybar" "Done!"
