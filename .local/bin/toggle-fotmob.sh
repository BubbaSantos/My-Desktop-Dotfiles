#!/bin/bash
ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("www.fotmob.com")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch togglespecialworkspace fotmob
else
    chromium --profile-directory="Profile 1" --app="https://www.fotmob.com/en" \
        --hide-scrollbars \
        --enable-features=UseOzonePlatform,WebAppWindowControlsOverlay,LinuxSystemURLHandler \
        --disable-features=WaylandWpColorManagerV1,WebContentsForceDark \
        --ozone-platform=wayland &
fi
