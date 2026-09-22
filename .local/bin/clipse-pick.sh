#!/usr/bin/env bash
# Opens clipse to pick an item, then auto-pastes it into whatever window was
# focused beforehand. clipse's own autoPaste stays disabled (see
# ~/.config/clipse/config.json) — it kills whatever launched it the instant
# it starts up, which means a wrapper script here can never detect
# completion or run anything after it. So the paste is done manually below
# instead, using sendshortcut (Shift+Insert works in terminals too, unlike
# Ctrl+V) once clipse has actually exited and we know a pick happened.
LAST_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
HIST_FILE="$HOME/.config/clipse/clipboard_history.json"
before_hash=$(wl-paste 2>/dev/null | sha1sum)
before_mtime=$(stat -c %Y "$HIST_FILE" 2>/dev/null)

alacritty --class clipse -e clipse

after_hash=$(wl-paste 2>/dev/null | sha1sum)
after_mtime=$(stat -c %Y "$HIST_FILE" 2>/dev/null)

if [ "$before_hash" != "$after_hash" ] || [ "$before_mtime" != "$after_mtime" ]; then
    sleep 0.1
    hyprctl dispatch focuswindow address:$LAST_WINDOW
    sleep 0.15
    hyprctl dispatch sendshortcut "SHIFT,Insert,address:$LAST_WINDOW"
    qs ipc -c "QuickShell Bar" call clipboard showPasted
fi
