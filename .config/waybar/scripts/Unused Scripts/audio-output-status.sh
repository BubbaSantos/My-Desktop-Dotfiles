#!/bin/bash

CURRENT_SINK=$(pactl get-default-sink)

if [[ "$CURRENT_SINK" == *"Poly_BT700"* ]]; then
    echo '{"text":"","class":"poly","tooltip":"Poly BT700"}'
else
    echo '{"text":"","class":"logi","tooltip":"Logi Z407"}'
fi
