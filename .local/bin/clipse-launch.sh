#!/bin/bash
# clipse's own autoPaste kills its launcher wrapper on startup (confirmed via
# clipse.log: "Killing pid ..., cmd .../clipse-launch.sh", fired the instant
# clipse starts, before any selection) — it assumes any such wrapper will
# conflict with its own focus-restore+paste, so it defends against that by
# killing it outright. That meant nothing after `clipse` here ever ran. So
# autoPaste is disabled (~/.config/clipse/config.json) and this script does
# the focus+paste itself instead, same as before.
LAST_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
HIST_FILE="$HOME/.config/clipse/clipboard_history.json"
before=$(stat -c %Y "$HIST_FILE" 2>/dev/null)

alacritty --class clipse -e clipse

after=$(stat -c %Y "$HIST_FILE" 2>/dev/null)
if [ -n "$after" ] && [ "$before" != "$after" ]; then
    sleep 0.1
    hyprctl dispatch focuswindow address:$LAST_WINDOW
    sleep 0.15
    hyprctl dispatch sendshortcut "ctrl,v,address:$LAST_WINDOW"
    qs ipc -c "QuickShell Bar" call clipboard showPasted
fi
