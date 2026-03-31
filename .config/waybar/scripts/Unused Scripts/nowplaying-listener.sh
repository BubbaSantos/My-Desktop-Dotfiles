#!/bin/bash
# ~/.config/waybar/scripts/nowplaying-listener.sh

pkill -f "playerctl.*follow"

# Monitor all players for any changes
playerctl -F metadata 2>/dev/null | while read -r _; do
    sleep 0.2
    pkill -RTMIN+8 waybar
    
    # Validate after a short delay
    (
        sleep 0.5
        # Check if waybar module shows content when it should
        if playerctl status 2>/dev/null | grep -q "Playing\|Paused"; then
            # Trigger one more update to be safe
            pkill -RTMIN+8 waybar
        fi
    ) &
done
