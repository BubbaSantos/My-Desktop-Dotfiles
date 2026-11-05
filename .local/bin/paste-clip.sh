#!/usr/bin/env bash
# Pastes the Nth entry of the clipse history (same numbering as the clipse list).
# Copying an entry makes clipse move it to the top of the history, which would
# shuffle the numbers, so the history file is snapshotted first and put back
# once clipse's listener has seen the copy.
N=$1
HIST="$HOME/.config/clipse/clipboard_history.json"
[ -n "$N" ] || exit 1

ENTRY=$(jq -c ".clipboardHistory[$((N-1))] // empty" "$HIST")
[ -n "$ENTRY" ] || { notify-send -a " " "Clip $N" "No clip at that number" -t 1500; exit 0; }

FILE=$(jq -r '.filePath' <<<"$ENTRY")
SNAP=$(cat "$HIST")

if [ "$FILE" != "null" ] && [ -f "$FILE" ]; then
    wl-copy < "$FILE"
else
    jq -j '.value' <<<"$ENTRY" | wl-copy
fi
sleep 0.1
hyprctl dispatch sendshortcut "SHIFT,Insert,activewindow"
sleep 0.5
printf '%s' "$SNAP" > "$HIST"
