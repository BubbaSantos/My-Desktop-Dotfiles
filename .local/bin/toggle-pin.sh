#!/bin/bash
# Pin only works on floating windows, so a tiled/pseudotiled window (e.g. Teams)
# is floated first, and put back in the layout when it is unpinned again.

win=$(hyprctl activewindow -j)
addr=$(jq -r '.address' <<< "$win")
is_pinned=$(jq -r '.pinned' <<< "$win")
is_floating=$(jq -r '.floating' <<< "$win")
mark="${XDG_RUNTIME_DIR:-/tmp}/toggle-pin-floated-$addr"

if [ "$is_pinned" = "true" ]; then
    hyprctl dispatch pin
    if [ -e "$mark" ]; then
        rm -f "$mark"
        hyprctl dispatch settiled
    fi
    notify-send -a "Hyprland" "Window Unpinned"
else
    if [ "$is_floating" != "true" ]; then
        hyprctl dispatch setfloating
        touch "$mark"
    fi
    hyprctl dispatch pin
    notify-send -a "Hyprland" "Window Pinned"
fi
