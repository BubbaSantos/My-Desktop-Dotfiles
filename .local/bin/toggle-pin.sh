#!/bin/bash

# Get current window address
window=$(hyprctl activewindow -j | jq -r '.address')

# Check if window is pinned by looking at the pinned field
is_pinned=$(hyprctl activewindow -j | jq -r '.pinned')

if [ "$is_pinned" = "true" ]; then
    hyprctl dispatch pin
    notify-send -a "Hyprland" "Window Unpinned"
else
    hyprctl dispatch pin
    notify-send -a "Hyprland" "Window Pinned"
fi
