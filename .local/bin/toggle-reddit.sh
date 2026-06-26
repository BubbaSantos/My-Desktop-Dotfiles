#!/bin/bash
ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("www.reddit.com")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch togglespecialworkspace reddit
else
    hyprctl dispatch togglespecialworkspace reddit
    chromium --profile-directory="Profile 1" --app="https://www.reddit.com" \
        --hide-scrollbars \
        --enable-features=UseOzonePlatform,WebAppWindowControlsOverlay,LinuxSystemURLHandler \
        --disable-features=WaylandWpColorManagerV1,WebContentsForceDark \
        --ozone-platform=wayland &
fi
