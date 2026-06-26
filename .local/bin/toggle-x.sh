#!/bin/bash
ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("x.com")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch togglespecialworkspace x
else
    chromium --profile-directory="Profile 1" --app="https://x.com" \
        --hide-scrollbars \
        --enable-features=UseOzonePlatform,WebAppWindowControlsOverlay,LinuxSystemURLHandler \
        --disable-features=WaylandWpColorManagerV1,WebContentsForceDark \
        --ozone-platform=wayland &
fi
