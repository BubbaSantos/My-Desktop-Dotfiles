#!/bin/bash
ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("outlook.cloud.microsoft")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch focuswindow "address:$ADDRESS"
else
    chromium --profile-directory="Profile 2" --app="https://outlook.cloud.microsoft" \
        --hide-scrollbars \
        --enable-features=UseOzonePlatform,WebAppWindowControlsOverlay,LinuxSystemURLHandler \
        --disable-features=WaylandWpColorManagerV1,WebContentsForceDark \
        --ozone-platform=wayland &
fi
