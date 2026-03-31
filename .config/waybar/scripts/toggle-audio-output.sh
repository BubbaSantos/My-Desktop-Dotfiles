#!/bin/bash
LOGI_SINK="alsa_output.usb-Logitech_Logi_Z407_00000000-01.analog-stereo"
SCARLETT_SINK="alsa_output.usb-Focusrite_Scarlett_Solo_4th_Gen_S10C9VN3C2C4D1-00.HiFi__Line1__sink"
CURRENT_SINK=$(pactl get-default-sink)
# Toggle between only Logitech and Scarlett Solo
if [[ "$CURRENT_SINK" == "$SCARLETT_SINK" ]]; then
    pactl set-default-sink "$LOGI_SINK"
    notify-send -t 2000 "Audio Output" "Switched to Logi Z407"
else
    pactl set-default-sink "$SCARLETT_SINK"
    notify-send -t 2000 "Audio Output" "Switched to Scarlett Solo"
fi
NEW_SINK=$(pactl get-default-sink)
# Move all active streams to the new sink
pactl list short sink-inputs | while read -r stream; do
    streamId=$(echo "$stream" | cut -f1)
    pactl move-sink-input "$streamId" "$NEW_SINK"
done
# Refresh only the audio-output module using signal 8
pkill -RTMIN+8 waybar
