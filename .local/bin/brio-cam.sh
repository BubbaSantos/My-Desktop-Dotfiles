#!/usr/bin/env bash
DEVICE="/dev/webcam"

# Zoom control
ZOOM_STEP=5
ZOOM_MIN=100
ZOOM_MAX=500

# Pan control (device reports step 3600)
PAN_STEP=3600
PAN_MIN=-36000
PAN_MAX=36000

# Focus control
FOCUS_STEP=5
FOCUS_MIN=0
FOCUS_MAX=255

get_ctrl() {
  v4l2-ctl -d "$DEVICE" --get-ctrl="$1" | awk '{print $2}'
}

set_ctrl() {
  v4l2-ctl -d "$DEVICE" --set-ctrl="$1=$2"
}

clamp() {
  local v="$1"
  local min="$2"
  local max="$3"
  if [ "$v" -gt "$max" ]; then
    echo "$max"
  elif [ "$v" -lt "$min" ]; then
    echo "$min"
  else
    echo "$v"
  fi
}

case "$1" in
  zoom_in)
    cur=$(get_ctrl zoom_absolute)
    new=$((cur + ZOOM_STEP))
    new=$(clamp "$new" "$ZOOM_MIN" "$ZOOM_MAX")
    set_ctrl zoom_absolute "$new"
    ;;
  zoom_out)
    cur=$(get_ctrl zoom_absolute)
    new=$((cur - ZOOM_STEP))
    new=$(clamp "$new" "$ZOOM_MIN" "$ZOOM_MAX")
    set_ctrl zoom_absolute "$new"
    ;;
  pan_left)
    cur=$(get_ctrl pan_absolute)
    new=$((cur - PAN_STEP))
    new=$(clamp "$new" "$PAN_MIN" "$PAN_MAX")
    set_ctrl pan_absolute "$new"
    ;;
  pan_right)
    cur=$(get_ctrl pan_absolute)
    new=$((cur + PAN_STEP))
    new=$(clamp "$new" "$PAN_MIN" "$PAN_MAX")
    set_ctrl pan_absolute "$new"
    ;;
  pan_up)
    cur=$(get_ctrl tilt_absolute)
    new=$((cur + PAN_STEP))
    new=$(clamp "$new" "$PAN_MIN" "$PAN_MAX")
    set_ctrl tilt_absolute "$new"
    ;;
  pan_down)
    cur=$(get_ctrl tilt_absolute)
    new=$((cur - PAN_STEP))
    new=$(clamp "$new" "$PAN_MIN" "$PAN_MAX")
    set_ctrl tilt_absolute "$new"
    ;;
  autofocus_on)
    set_ctrl focus_automatic_continuous 1
    ;;
  autofocus_off)
    set_ctrl focus_automatic_continuous 0
    ;;
  autofocus_toggle)
    cur=$(get_ctrl focus_automatic_continuous)
    if [ "$cur" -eq 1 ]; then
      set_ctrl focus_automatic_continuous 0
      echo "Autofocus: OFF"
    else
      set_ctrl focus_automatic_continuous 1
      echo "Autofocus: ON"
    fi
    ;;
  focus_near)
    set_ctrl focus_automatic_continuous 0
    cur=$(get_ctrl focus_absolute)
    new=$((cur - FOCUS_STEP))
    new=$(clamp "$new" "$FOCUS_MIN" "$FOCUS_MAX")
    set_ctrl focus_absolute "$new"
    ;;
  focus_far)
    set_ctrl focus_automatic_continuous 0
    cur=$(get_ctrl focus_absolute)
    new=$((cur + FOCUS_STEP))
    new=$(clamp "$new" "$FOCUS_MIN" "$FOCUS_MAX")
    set_ctrl focus_absolute "$new"
    ;;
  centre|center)
    set_ctrl pan_absolute 0
    set_ctrl tilt_absolute 0
    set_ctrl zoom_absolute "$ZOOM_MIN"
    ;;
  *)
    echo "Usage: $0 {zoom_in|zoom_out|pan_left|pan_right|pan_up|pan_down|centre|autofocus_on|autofocus_off|autofocus_toggle|focus_near|focus_far}"
    exit 1
    ;;
esac
