#!/bin/sh
set -eu

WIN_JSON="$(hyprctl activewindow -j)"
CLASS="$(printf "%s" "$WIN_JSON" | jq -r '.class')"

# A pseudotiled window leaves pseudo mode before it is floated
has_pseudo() { printf "%s" "$WIN_JSON" | jq -e '.tags | index("pseudo")' >/dev/null; }
if [ "$(printf "%s" "$WIN_JSON" | jq -r '.floating')" != true ] && has_pseudo; then
  hyprctl dispatch pseudo
  hyprctl dispatch tagwindow "pseudo address:$(printf "%s" "$WIN_JSON" | jq -r .address)"
fi

# A floating window going back to tiled must not come back pseudotiled
if [ "$(printf "%s" "$WIN_JSON" | jq -r '.floating')" = true ] && [ "$CLASS" != teams-for-linux ]; then
  hyprctl dispatch togglefloating
  if has_pseudo; then
    hyprctl dispatch pseudo
    hyprctl dispatch tagwindow "pseudo address:$(printf "%s" "$WIN_JSON" | jq -r .address)"
  fi
  exit 0
fi

# Toggle floating first, except for teams-for-linux which is managed separately
case "$CLASS" in
  teams-for-linux) ;;
  *) hyprctl dispatch togglefloating ;;
esac

SINGLE=0
[ "$(~/.local/bin/monitor-mode status)" = "Current mode: single" ] && SINGLE=1

# Helper: centre the active window on its current monitor using monitor geometry
center_on_current_monitor() {
  local win
  win="$(hyprctl activewindow -j)"
  local mon_id
  mon_id="$(printf "%s" "$win" | jq -r '.monitor')"

  local mon
  mon="$(hyprctl monitors -j | jq -r ".[] | select(.id == $mon_id)")"
  local mx my mw mh
  mx="$(printf "%s" "$mon" | jq -r '.x')"
  my="$(printf "%s" "$mon" | jq -r '.y')"
  mw="$(printf "%s" "$mon" | jq -r '.width')"
  mh="$(printf "%s" "$mon" | jq -r '.height')"

  local ww wh
  ww="$(hyprctl activewindow -j | jq -r '.size[0]')"
  wh="$(hyprctl activewindow -j | jq -r '.size[1]')"

  local nx ny
  nx=$(( mx + (mw - ww) / 2 ))
  ny=$(( my + (mh - wh) / 2 ))

  hyprctl dispatch moveactive exact "$nx" "$ny"
}

case "$CLASS" in
  Alacritty|floating-terminal)
    hyprctl dispatch resizeactive exact 637 737
    center_on_current_monitor
    ;;
  chrome-claude.ai__new-Profile_1)
    hyprctl dispatch resizeactive exact 600 1200
    center_on_current_monitor
    ;;
  chrome-chatgpt.com__-Profile_1)
    hyprctl dispatch resizeactive exact 600 1200
    center_on_current_monitor
    ;;
  teams-for-linux)
    TEAMS_ADDR="$(hyprctl clients -j | jq -r '.[] | select(.class == "teams-for-linux") | .address')"
    FLOATING="$(hyprctl clients -j | jq -r '.[] | select(.class == "teams-for-linux") | .floating')"
    hyprctl dispatch focuswindow address:"$TEAMS_ADDR"
    sleep 0.05
    if [ "$FLOATING" = "true" ]; then
      hyprctl dispatch togglefloating
    else
      hyprctl dispatch togglefloating
      hyprctl dispatch resizeactive exact 527 392
      if [ "$SINGLE" = 1 ]; then ~/.local/bin/float-fit.sh center; else hyprctl dispatch moveactive exact 3250 550; fi
    fi
    ;;
  vivaldi-stable)
    hyprctl dispatch resizeactive exact 1163 971
    center_on_current_monitor
    ;;
  chrome-www.youtube.com__-Profile_1)
    hyprctl dispatch resizeactive exact 1696 1360
    center_on_current_monitor
    ;;
  chrome-www.twitch.tv__-Default)
    hyprctl dispatch resizeactive exact 1498 1332
    if [ "$SINGLE" = 1 ]; then center_on_current_monitor; else hyprctl dispatch moveactive exact 2760 531; fi
    ;;
  *)
    hyprctl dispatch resizeactive exact 1696 1360
    center_on_current_monitor
    ;;
esac

# Safety net: never leave the window off-screen or larger than the monitor
[ "$CLASS" = teams-for-linux ] || ~/.local/bin/float-fit.sh
