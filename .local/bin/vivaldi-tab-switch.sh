#!/bin/bash

# Get the active window class
active_class=$(hyprctl activewindow -j | jq -r '.class')

# Check if it's Vivaldi
if [[ "$active_class" == "Vivaldi-stable" ]] || [[ "$active_class" == "vivaldi-stable" ]]; then
    # Send Alt+Q
    ydotool key 56:1 16:1 16:0 56:0
else
    # Send Ctrl+Tab (for other applications)
    ydotool key 29:1 15:1 15:0 29:0
fi
