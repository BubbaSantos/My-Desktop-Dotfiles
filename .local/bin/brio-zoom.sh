#!/usr/bin/env bash

DEVICE="/dev/video0"
STEP=20
MIN=100
MAX=500

CURRENT=$(v4l2-ctl -d "$DEVICE" --get-ctrl=zoom_absolute | awk '{print $2}')

case "$1" in
  in)
    NEW=$((CURRENT + STEP))
    ;;
  out)
    NEW=$((CURRENT - STEP))
    ;;
  *)
    exit 1
    ;;
esac

# Clamp value
if [ "$NEW" -gt "$MAX" ]; then
  NEW="$MAX"
elif [ "$NEW" -lt "$MIN" ]; then
  NEW="$MIN"
fi

v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute="$NEW"

