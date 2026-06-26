#!/usr/bin/env bash

MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
PREV_FILE="/tmp/hypr-prev-${MONITOR}"

if [[ ! -f "$PREV_FILE" ]]; then
    exit 0
fi

PREV=$(cat "$PREV_FILE")
CURRENT=$(hyprctl activeworkspace -j | jq -r '.id')

if [[ -n "$PREV" && "$PREV" != "$CURRENT" ]]; then
    hyprctl dispatch workspace "$PREV"
fi
