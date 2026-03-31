#!/bin/bash
# ~/.config/waybar/scripts/nowplaying-title.sh

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

# Get the first active player
player=$(playerctl -l 2>/dev/null | head -n1)

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

# Escape title for display
title_esc=$(escape_text "$title")

# Build display text and tooltip
if [ "$HIDDEN" = true ]; then
    display_text="🎵 Playing"
    tooltip="Track hidden"
else
    display_text="$title_esc"

    tooltip="$title"
    [ -n "$artist" ] && tooltip="$tooltip\\n$artist"
    [ -n "$album" ] && tooltip="$tooltip\\n$album"
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
