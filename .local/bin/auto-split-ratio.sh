#!/bin/bash
RATIO_FILE="$HOME/.cache/hypr-split-ratio"

get_ratio() {
    cat "$RATIO_FILE" 2>/dev/null || echo "1.55"
}

handle() {
    if [[ ${1:0:12} == "openwindow>>" ]]; then
        workspace=$(hyprctl activeworkspace -j | jq '.id')
        count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $workspace)] | length")

        if [[ "$count" -eq 1 ]]; then
            hyprctl keyword dwindle:default_split_ratio "$(get_ratio)"
        else
            hyprctl keyword dwindle:default_split_ratio 1.0
        fi
    fi
}

sleep 2

HISIG=$(ls /run/user/$(id -u)/hypr/ 2>/dev/null | head -n1)

while true; do
    socat -u "UNIX-CONNECT:/run/user/$(id -u)/hypr/$HISIG/.socket2.sock" STDOUT | while read -r line; do
        handle "$line"
    done
    sleep 1
done
