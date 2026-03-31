#!/bin/bash

LOGI_SINK="alsa_output.usb-Logitech_Logi_Z407_00000000-01.analog-stereo"
POLY_SINK="alsa_output.usb-Plantronics_Poly_BT700_91C70F0D457C44E08DDC61123ED2D73B-00.iec958-stereo"
VOCASTER_SINK="alsa_output.usb-Focusrite_Vocaster_One_USB_V1W6TU82804E77-00.analog-surround-40"

# Use rofi or wofi for menu (adjust based on what you use)
#MENU_CMD="wofi --dmenu -p 'Select Audio Output'"
# If you use rofi instead, uncomment this:
MENU_CMD="rofi -dmenu -p 'Select Audio Output'"

choice=$(echo -e "󰓃 Logitech Z407\n Poly BT700\n Vocaster One" | $MENU_CMD)

case "$choice" in
    "󰓃 Logitech Z407")
        pactl set-default-sink "$LOGI_SINK"
        notify-send -t 2000 "Audio Output" "Switched to Logi Z407"
        ;;
    " Poly BT700")
        pactl set-default-sink "$POLY_SINK"
        notify-send -t 2000 "Audio Output" "Switched to Poly BT700"
        ;;
    " Vocaster One")
        pactl set-default-sink "$VOCASTER_SINK"
        notify-send -t 2000 "Audio Output" "Switched to Vocaster One"
        ;;
esac

# Move all active streams to new sink
if [ -n "$choice" ]; then
    NEW_SINK=$(pactl get-default-sink)
    pactl list short sink-inputs | while read -r stream; do
        streamId=$(echo "$stream" | cut -f1)
        pactl move-sink-input "$streamId" "$NEW_SINK"
    done
    
    # Reload waybar to refresh pulseaudio module
    ~/.config/waybar/refresh-bars.sh
fi
