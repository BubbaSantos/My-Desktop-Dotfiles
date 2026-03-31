#!/usr/bin/env bash
set -euo pipefail

action="${1:?up|down|toggle}"
step="${2:-2}"

sink="$(pactl get-default-sink)"

case "$action" in
  up) pamixer --sink "$sink" -i "$step" ;;
  down) pamixer --sink "$sink" -d "$step" ;;
  toggle) pamixer --sink "$sink" -t ;;
  *) exit 1 ;;
esac

