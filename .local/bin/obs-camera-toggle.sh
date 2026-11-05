#!/bin/sh
# Start OBS with the virtual camera, or quit it so the webcam is released.
if pgrep -x obs >/dev/null; then
  pkill -TERM -x obs
  notify-send -t 2000 "OBS" "Closed, camera released"
else
  hyprctl dispatch exec "[workspace special:obs silent] obs --startvirtualcam --disable-shutdown-check" >/dev/null
  notify-send -t 2000 "OBS" "Starting with virtual camera"
fi
