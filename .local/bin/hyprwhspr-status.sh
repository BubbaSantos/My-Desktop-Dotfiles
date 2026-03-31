#!/usr/bin/env bash

case "$1" in
  status)
    # Check mute state first
    muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -c "yes")

    # Get hyprwhspr status
    original=$(bash /usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh status)
    class=$(echo "$original" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('class',''))" 2>/dev/null)
    tooltip=$(echo "$original" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tooltip',''))" 2>/dev/null)

    # Recording takes priority over mute indicator
    if [[ "$class" == "recording" ]]; then
      echo "$original"
    elif [[ "$muted" -eq 1 ]]; then
      echo "{\"text\": \"󰍭\", \"tooltip\": \"Mic muted\", \"class\": \"muted\"}"
    else
      echo "$original"
    fi
    ;;
  record)
    bash /usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh record
    ;;
  toggle-mute)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -c "yes")
    if [[ "$muted" -eq 1 ]]; then
      notify-send -u critical -r 9991 -t 0 "Mic muted"
    else
      makoctl dismiss --all
      notify-send -t 2000 "Mic unmuted"
    fi
    pkill -RTMIN+2 waybar
    ;;
  *)
    bash /usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh "$@"
    ;;
esac
