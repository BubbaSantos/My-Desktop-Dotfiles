#!/bin/sh
set -eu

# Format: W,H or W,H,X,Y (X,Y are global coords; omit to centre on current monitor)
# Dual-monitor sizes (first one is pinned to the second screen); single-monitor sizes are centred
if [ "$(~/.local/bin/monitor-mode status)" = "Current mode: single" ]; then
  SIZES="1719,1394 1291,1394 751,423"
else
  SIZES="1719,1394,2661,514 1291,1394 751,423"
fi
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr-cycle-size"
mkdir -p "$STATE_DIR"

WIN_JSON="$(hyprctl activewindow -j)"
CLASS="$(printf "%s" "$WIN_JSON" | jq -r '.class')"
WIN_ADDR="$(printf "%s" "$WIN_JSON" | jq -r '.address')"
FLOATING="$(printf "%s" "$WIN_JSON" | jq -r '.floating')"

STATE_FILE="$STATE_DIR/$WIN_ADDR"

# Read current index, default to -1 so first press lands on index 0 (largest)
if [ -f "$STATE_FILE" ]; then
  CURRENT="$(cat "$STATE_FILE")"
else
  CURRENT=-1
fi

NEXT=$(( (CURRENT + 1) % 3 ))
printf "%s" "$NEXT" > "$STATE_FILE"

SIZE="$(printf "%s" "$SIZES" | tr ' ' '\n' | sed -n "$((NEXT + 1))p")"
W="$(printf "%s" "$SIZE" | cut -d',' -f1)"
H="$(printf "%s" "$SIZE" | cut -d',' -f2)"
X="$(printf "%s" "$SIZE" | cut -d',' -f3)"
Y="$(printf "%s" "$SIZE" | cut -d',' -f4)"

# Only float if not already floating
case "$CLASS" in
  teams-for-linux) ;;
  *)
    if [ "$FLOATING" = "false" ]; then
      hyprctl dispatch togglefloating
    fi
    ;;
esac

center_on_current_monitor() {
  local win mon_id mon mx my mw mh ww wh nx ny
  win="$(hyprctl activewindow -j)"
  mon_id="$(printf "%s" "$win" | jq -r '.monitor')"
  mon="$(hyprctl monitors -j | jq -r ".[] | select(.id == $mon_id)")"
  mx="$(printf "%s" "$mon" | jq -r '.x')"
  my="$(printf "%s" "$mon" | jq -r '.y')"
  mw="$(printf "%s" "$mon" | jq -r '.width')"
  mh="$(printf "%s" "$mon" | jq -r '.height')"
  ww="$(hyprctl activewindow -j | jq -r '.size[0]')"
  wh="$(hyprctl activewindow -j | jq -r '.size[1]')"
  nx=$(( mx + (mw - ww) / 2 ))
  ny=$(( my + (mh - wh) / 2 ))
  hyprctl dispatch moveactive exact "$nx" "$ny"
}

place_window() {
  if [ -n "$X" ] && [ -n "$Y" ]; then
    hyprctl dispatch moveactive exact "$X" "$Y"
  else
    center_on_current_monitor
  fi
}

case "$CLASS" in
  teams-for-linux)
    TEAMS_ADDR="$(hyprctl clients -j | jq -r '.[] | select(.class == "teams-for-linux") | .address')"
    hyprctl dispatch focuswindow address:"$TEAMS_ADDR"
    sleep 0.05
    if [ "$FLOATING" = "false" ]; then
      hyprctl dispatch togglefloating
    fi
    hyprctl dispatch resizeactive exact "$W" "$H"
    place_window
    ;;
  *)
    hyprctl dispatch resizeactive exact "$W" "$H"
    place_window
    ;;
esac

# Safety net: never leave the window off-screen or larger than the monitor
~/.local/bin/float-fit.sh
