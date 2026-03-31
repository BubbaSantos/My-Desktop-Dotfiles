#!/bin/bash

CURRENT_SOURCE=$(pactl get-default-source)

if echo "$CURRENT_SOURCE" | grep -qi "Focusrite\|Vocaster"; then
    icon=""
    tooltip="Input: Vocaster One"
elif echo "$CURRENT_SOURCE" | grep -qi "Logitech\|Brio\|046d"; then
    icon="󰖠"
    tooltip="Input: Logitech Brio"
else
    icon=""
    tooltip="Input: $CURRENT_SOURCE"
fi

echo "{\"text\":\"$icon\", \"tooltip\":\"$tooltip\"}"
