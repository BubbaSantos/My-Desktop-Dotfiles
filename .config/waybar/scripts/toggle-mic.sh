#!/bin/bash
CURRENT_SOURCE=$(pactl get-default-source)
VOCASTER_SOURCE="alsa_input.usb-Focusrite_Vocaster_One_USB_V1W6TU82804E77-00.pro-input-0"
BRIO_SOURCE="alsa_input.usb-046d_Logi_4K_Stream_Edition_794150B8-03.iec958-stereo"

if echo "$CURRENT_SOURCE" | grep -qi "Focusrite\|Vocaster"; then
    pactl set-default-source "$BRIO_SOURCE"
    notify-send -t 2000 "Microphone" "Switched to Logitech Brio"
else
    pactl set-default-source "$VOCASTER_SOURCE"
    notify-send -t 2000 "Microphone" "Switched to Vocaster One"
fi

pkill -RTMIN+7 waybar
