#!/usr/bin/env bash
# Force Num Lock on every time this key is pressed
numlockx on >/dev/null 2>&1

# Check if calculator is running
if hyprctl clients | grep -q "org.gnome.Calculator"; then
    # Check if calculator is focused
    if hyprctl activewindow -j | jq -e '.class=="org.gnome.Calculator"' > /dev/null 2>&1; then
        # Calculator is focused, close it
        hyprctl dispatch closewindow class:^org.gnome.Calculator$
    else
        # Calculator exists but not focused, focus it
        hyprctl dispatch focuswindow class:^org.gnome.Calculator$
    fi
else
    # Calculator not running, launch it
    gnome-calculator &
    sleep 0.3
    hyprctl dispatch focuswindow class:^org.gnome.Calculator$
fi
