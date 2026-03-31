#!/bin/bash

# Singleton check - only allow one instance of this script
PIDFILE="/tmp/waybar-cava.pid"

# Check if another instance is running
if [ -f "$PIDFILE" ]; then
    OLD_PID=$(cat "$PIDFILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        # Another instance is running, kill it
        kill "$OLD_PID" 2>/dev/null
        sleep 0.2
    fi
fi

# Write our PID
echo $$ > "$PIDFILE"

# Cleanup function
cleanup() {
    pkill -P $$ 2>/dev/null  # Kill all child processes
    rm -f "$PIDFILE"
    exit 0
}

# Trap exit signals
trap cleanup EXIT INT TERM

# Kill any existing cava instances for waybar
pkill -f "cava -p.*waybar"

# Variables for delay
silent_count=0
max_silent_frames=300  # 5 seconds at 60fps

# Cava config for waybar
cava -p <(cat <<EOF
[general]
bars = 8
framerate = 60
[input]
method = pulse
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 32
[smoothing]
noise_reduction = 75
EOF
) | while read -r line; do
    # Check if anything is playing (check all players)
    is_playing=false
    for player in $(playerctl -l 2>/dev/null); do
        status=$(playerctl -p "$player" status 2>/dev/null)
        if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
            is_playing=true
            break
        fi
    done
    
    if [ "$is_playing" = false ]; then
        echo ""
        continue
    fi
    
    # Check if there's any audio activity (values > 0)
    has_audio=false
    for val in $line; do
        if [ "$val" -gt 0 ]; then
            has_audio=true
            break
        fi
    done
    
    # Only output if there's audio
    if [ "$has_audio" = true ]; then
        silent_count=0
        
        # Convert cava output to block characters with spaces
        output=""
        for val in $line; do
            case $val in
                0) output+="▁";;
                1) output+="▂";;
                2) output+="▃";;
                3) output+="▄";;
                4) output+="▅";;
                5) output+="▆";;
                6) output+="▇";;
                7) output+="█";;
            esac
            output+=" "
        done
        echo "$output"
    else
        ((silent_count++))
        
        if [ $silent_count -ge $max_silent_frames ]; then
            echo ""
        else
            echo "▁ ▁ ▁ ▁ ▁ ▁ ▁ ▁ "
        fi
    fi
done
