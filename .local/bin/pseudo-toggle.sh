#!/bin/sh
# Toggle pseudotiling and mirror it in a "pseudo" window tag, because hyprctl
# doesn't report pseudo state. The tag is read by float-size.sh and the bar.
addr="$(hyprctl activewindow -j | jq -r '.address')"
hyprctl dispatch tagwindow "pseudo address:$addr"
hyprctl dispatch pseudo
