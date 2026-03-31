#!/bin/bash

# Get the current workspace ID
workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Get all windows on this workspace
windows=$(hyprctl clients -j | jq -c ".[] | select(.workspace.id == $workspace)")

# Determine if we need to tile or float all windows
should_tile=false

while IFS= read -r win; do
    floating=$(echo "$win" | jq -r '.floating')
    if [ "$floating" == "true" ]; then
        should_tile=true
        break
    fi
done <<< "$windows"

if [ "$should_tile" == "true" ]; then
    # Tile all windows
    while IFS= read -r win; do
        win_address=$(echo "$win" | jq -r '.address')
        hyprctl dispatch togglefloating address:$win_address
    done <<< "$windows"
else
    # Float all windows and apply sizes
    while IFS= read -r win; do
        class=$(echo "$win" | jq -r '.class')
        win_address=$(echo "$win" | jq -r '.address')
        hyprctl dispatch togglefloating address:$win_address

        # Add a small delay to let floating state apply
        sleep 0.1

        case "$class" in
            chrome-claude.ai__new-Profile_1|chrome-chatgpt.com__-Profile_1)
                hyprctl dispatch resizeactive exact 600 1200
                hyprctl dispatch moveactive center
                ;;
            chrome-teams.microsoft.com__v2_-Profile_1)
                hyprctl dispatch resizeactive exact 527 392
                hyprctl dispatch moveactive exact 4237 550
                ;;
            vivaldi-stable)
                hyprctl dispatch resizeactive exact 1163 971
                hyprctl dispatch moveactive center
                ;;
        esac
    done <<< "$windows"
fi
