!/bin/bash
ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("teams.microsoft.com")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch focuswindow "address:$ADDRESS"
else
    chromium --profile-directory="Profile 1" --app="https://teams.microsoft.com/v2/" \
        --enable-features=WebAppWindowControlsOverlay \
        --disable-features=VaapiVideoDecoder,WaylandWpColorManagerV1,WebContentsForceDark \
        --force-device-scale-factor=1.25
        --ozone-platform=wayland &
fi
