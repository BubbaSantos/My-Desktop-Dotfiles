#!/bin/sh
set -eu

SIZES="1696,1360 1291,1360 831,573"
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/hypr-cycle-size"
mkdir -p "$STATE_DIR"

WIN_JSON="$(hyprctl activewindow -j)"
CLASS="$(printf "%s" "$WIN_JSON" | jq -r '.class')"
WIN_ADDR="$(printf "%s" "$WIN_JSON" | jq -r '.address')"
FLOATING="$(printf "%s" "$WIN_JSON" | jq -r '.floating')"

STATE_FILE="$STATE_DIR/$WIN_ADDR"

# Read current index, default to -1 so first press lands on index 0 (small)
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

case "$CLASS" in
  teams-for-linux)
    TEAMS_ADDR="$(hyprctl clients -j | jq -r '.[] | select(.class == "teams-for-linux") | .address')"
    hyprctl dispatch focuswindow address:"$TEAMS_ADDR"
    sleep 0.05
    if [ "$FLOATING" = "false" ]; then
      hyprctl dispatch togglefloating
    fi
    hyprctl dispatch resizeactive exact "$W" "$H"
    center_on_current_monitor
    ;;
  *)
    hyprctl dispatch resizeactive exact "$W" "$H"
    center_on_current_monitor
    ;;
esac
