#!/bin/bash
# Check if Reddit webapp is running
if hyprctl clients | grep -q "chrome-www.reddit.com__-Profile_1"; then
    # Toggle the special workspace
    hyprctl dispatch togglespecialworkspace reddit
else
    # Open special workspace first, then launch Reddit
    hyprctl dispatch togglespecialworkspace reddit
    chromium --profile-directory="Profile 1" --app="https://www.reddit.com" &
fi
