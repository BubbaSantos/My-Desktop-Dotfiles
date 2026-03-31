
#!/usr/bin/env bash
set -euo pipefail

action="${1:-get}"   # get | up | down | mute | toggle
step="${2:-2}"       # scroll step

# Your exact sink names
LOGI_SINK="alsa_output.usb-Logitech_Logi_Z407_00000000-01.analog-stereo"
POLY_SINK="alsa_output.usb-Plantronics_Poly_BT700_91C70F0D457C44E08DDC61123ED2D73B-00.iec958-stereo"

# Tuning
SPEAKER_CAP=40     # max percent for speakers
SPEAKER_STEP=1     # step when speakers are default
HEADSET_CAP=150    # allow boost on headset if you want
HEADSET_STEP="$step"

default_sink="$(pactl get-default-sink)"

is_speakers=0
is_headset=0
if [[ "$default_sink" == "$LOGI_SINK" ]]; then
  is_speakers=1
elif [[ "$default_sink" == "$POLY_SINK" ]]; then
  is_headset=1
fi

output_icon=""
output_name="Output"
if (( is_headset )); then
  output_icon=""
  output_name="Headset"
elif (( is_speakers )); then
  output_icon=""
  output_name="Speakers"
fi

speaker_icon=""

clamp_volume() {
  local sink="$1"
  local cap="$2"
  local cur
  cur="$(pamixer --sink "$sink" --get-volume)"
  if [[ "$cur" =~ ^[0-9]+$ ]] && (( cur > cap )); then
    pamixer --sink "$sink" --set-volume "$cap" >/dev/null
  fi
}

move_streams() {
  local sink="$1"
  pactl list short sink-inputs | while IFS=$'\t' read -r streamId _; do
    [[ -n "${streamId:-}" ]] && pactl move-sink-input "$streamId" "$sink" >/dev/null 2>&1 || true
  done
}

case "$action" in
  toggle)
    if [[ "$default_sink" == "$LOGI_SINK" ]]; then
      pactl set-default-sink "$POLY_SINK"
      move_streams "$POLY_SINK"
    else
      pactl set-default-sink "$LOGI_SINK"
      move_streams "$LOGI_SINK"
    fi
    default_sink="$(pactl get-default-sink)"
    ;;

  mute)
    pamixer --sink "$default_sink" -t >/dev/null
    ;;

  up|down)
    if (( is_speakers )); then
      if [[ "$action" == "up" ]]; then
        pamixer --sink "$default_sink" -i "$SPEAKER_STEP" >/dev/null
      else
        pamixer --sink "$default_sink" -d "$SPEAKER_STEP" >/dev/null
      fi
      clamp_volume "$default_sink" "$SPEAKER_CAP"
    else
      if [[ "$action" == "up" ]]; then
        pamixer --sink "$default_sink" -i "$HEADSET_STEP" >/dev/null
      else
        pamixer --sink "$default_sink" -d "$HEADSET_STEP" >/dev/null
      fi
      clamp_volume "$default_sink" "$HEADSET_CAP"
    fi
    ;;

  get) : ;;
  *) exit 1 ;;
esac

# Re read after actions
default_sink="$(pactl get-default-sink)"

# Re compute output label after action
output_icon=""
output_name="Output"
if [[ "$default_sink" == "$POLY_SINK" ]]; then
  output_icon=""
  output_name="Headset"
elif [[ "$default_sink" == "$LOGI_SINK" ]]; then
  output_icon=""
  output_name="Speakers"
fi

vol="$(pamixer --sink "$default_sink" --get-volume)"
mute="$(pamixer --sink "$default_sink" --get-mute)"

if [[ "$mute" == "true" ]]; then
  text="mute 󰝟"
else
  text="${output_icon} ${vol}% ${speaker_icon}"
fi

tooltip="${output_name}: ${default_sink}\nVolume: ${vol}%\nLeft click: mute\nScroll: volume\nRight click: switch output"

printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"
