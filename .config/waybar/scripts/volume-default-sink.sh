#!/usr/bin/env bash
set -euo pipefail

step="${1:-2}"   # percent
dir="${2:-up}"   # up or down

# PipeWire
if command -v wpctl >/dev/null 2>&1; then
  if [[ "$dir" == "up" ]]; then
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "${step}%+"
  else
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${step}%-"
  fi
  exit 0
fi

# PulseAudio
default_sink="$(pactl get-default-sink)"
if [[ "$dir" == "up" ]]; then
  pamixer --sink "$default_sink" -i "$step"
else
  pamixer --sink "$default_sink" -d "$step"
fi
