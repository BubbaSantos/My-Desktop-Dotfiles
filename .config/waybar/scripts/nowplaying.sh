#!/bin/bash
# ~/.config/waybar/scripts/nowplaying.sh
STATE_FILE="/tmp/waybar_nowplaying_hidden"
# Check if display is hidden
if [ -f "$STATE_FILE" ]; then
    HIDDEN=true
else
    HIDDEN=false
fi
# Escape for XML/HTML display
escape_text() {
    echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}
# Prefer a Playing player, fall back to first Paused one
player=""
playing_player=""
paused_player=""

while IFS= read -r p; do
    s=$(playerctl -p "$p" status 2>/dev/null)
    if [ "$s" = "Playing" ] && [ -z "$playing_player" ]; then
        playing_player="$p"
    elif [ "$s" = "Paused" ] && [ -z "$paused_player" ]; then
        paused_player="$p"
    fi
done < <(playerctl -l 2>/dev/null)

if [ -n "$playing_player" ]; then
    player="$playing_player"
elif [ -n "$paused_player" ]; then
    player="$paused_player"
fi

if [ -z "$player" ]; then
    echo '{"text": "", "tooltip": "No media player", "class": "stopped"}'
    exit 0
fi
# Get player status
status=$(playerctl -p "$player" status 2>/dev/null)
if [ "$status" != "Playing" ] && [ "$status" != "Paused" ]; then
    echo '{"text": "", "tooltip": "No media playing", "class": "stopped"}'
    exit 0
fi
# Get metadata
title=$(playerctl -p "$player" metadata title 2>/dev/null)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
album=$(playerctl -p "$player" metadata album 2>/dev/null)
# If no title, nothing to show
if [ -z "$title" ]; then
    echo '{"text": "", "tooltip": "No media information", "class": "stopped"}'
    exit 0
fi
# Escape for display
title_esc=$(escape_text "$title")
artist_esc=$(escape_text "$artist")
album_esc=$(escape_text "$album")
# Build display text
if [ "$HIDDEN" = true ]; then
    display_text="🎵 Playing"
    tooltip="Track hidden"
else
    if [ -n "$artist" ]; then
        display_text="$title_esc - $artist_esc"
    else
        display_text="$title_esc"
    fi
    
    tooltip="$title_esc"
    [ -n "$artist" ] && tooltip="$tooltip\\n$artist_esc"
    [ -n "$album" ] && tooltip="$tooltip\\n$album_esc"
fi
# Add pause icon if paused
if [ "$status" = "Paused" ]; then
    display_text="⏸ $display_text"
    css_class="paused"
else
    css_class="playing"
fi
# Output JSON
echo "{\"text\": \"$display_text\", \"tooltip\": \"$tooltip\", \"class\": \"$css_class\"}"
