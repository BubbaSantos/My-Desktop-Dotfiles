#!/usr/bin/env bash
case "$1" in
  status)
    muted=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -c "yes")
    if [[ "$muted" -eq 1 ]]; then
      echo "{\"text\": \"󰍭 mic muted\", \"tooltip\": \"Mic muted\", \"class\": \"muted\"}"
    else
      echo "{\"text\": \"󰍬\", \"tooltip\": \"Mic active\", \"class\": \"active\"}"
    fi
    ;;
  toggle-mute)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    pkill -RTMIN+2 waybar
    ;;
esac
