#!/bin/bash
# Get the address of the currently focused window
LAST_WINDOW=$(hyprctl activewindow -j | jq -r '.address')

# Launch clipse in alacritty and wait for it to close
kitty --class clipse -e clipse

# After clipse closes, focus the previous window and paste
sleep 0.1
hyprctl dispatch focuswindow address:$LAST_WINDOW
sleep 0.15
hyprctl dispatch sendshortcut ctrl,v,address:$LAST_WINDOW
