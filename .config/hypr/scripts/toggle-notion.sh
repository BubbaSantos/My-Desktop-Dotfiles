#!/bin/bash
ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("notion.so")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch focuswindow "address:$ADDRESS"
else
    chromium --profile-directory="Profile 1" --app="https://www.notion.so/" \
        --hide-scrollbars \
        --enable-features=WebAppWindowControlsOverlay \
        --disable-features=WaylandWpColorManagerV1,WebContentsForceDark \
        --lang=en-GB \
        --ozone-platform=wayland &
fi
