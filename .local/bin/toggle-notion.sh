#!/bin/bash
# Notion dock enabled (QuickShell Bar > Settings > Docks): dockctl owns the window.
#   toggle-notion.sh            toggle the dock (launching Notion first if needed)
#   toggle-notion.sh --launch   make sure Notion is running, hidden in the dock
# Dock disabled: the original behaviour — focus the Notion window, or launch it.
dock_on=$(jq -r '[.docks[]? | select(.id=="notion" and .enabled==true)] | length' ~/.config/hypr/docks.json 2>/dev/null)
if [[ $dock_on == 1 ]]; then
    [[ $1 == --launch ]] && exec dockctl launch notion
    exec dockctl toggle notion
fi

ADDRESS=$(hyprctl clients -j | jq -r '.[] | select(.class | contains("notion.so")) | .address' | head -1)
if [ -n "$ADDRESS" ]; then
    hyprctl dispatch focuswindow "address:$ADDRESS"
else
    chromium --profile-directory="Profile 1" --app="https://www.notion.so/" \
        --hide-scrollbars \
        --enable-features=UseOzonePlatform,WebAppWindowControlsOverlay,LinuxSystemURLHandler \
        --disable-features=WaylandWpColorManagerV1,WebContentsForceDark \
        --lang=en-GB \
        --ozone-platform=wayland &
fi
