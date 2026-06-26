#!/usr/bin/env bash

declare -A current

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    if [[ "$line" == workspace* ]]; then
        WS="${line#workspace>>}"
        MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
        PREV_FILE="/tmp/hypr-prev-${MONITOR}"
        CURR_FILE="/tmp/hypr-curr-${MONITOR}"

        if [[ -f "$CURR_FILE" ]]; then
            STORED=$(cat "$CURR_FILE")
            if [[ "$STORED" != "$WS" ]]; then
                echo "$STORED" > "$PREV_FILE"
                echo "$WS" > "$CURR_FILE"
            fi
        else
            echo "$WS" > "$CURR_FILE"
        fi
    fi
done
