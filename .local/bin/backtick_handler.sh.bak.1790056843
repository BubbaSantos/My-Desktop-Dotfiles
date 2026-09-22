#localectl status!/usr/bin/env bash
STATE_FILE="/tmp/backtick_state"
DOUBLE_PRESS_THRESHOLD=300
current_time=$(date +%s%3N)

if [ -f "$STATE_FILE" ]; then
    last_time=$(cat "$STATE_FILE")
    time_diff=$((current_time - last_time))
    
    if [ $time_diff -lt $DOUBLE_PRESS_THRESHOLD ]; then
        # Double press - select all and copy
        wtype -M ctrl -k a -k c -m ctrl
        rm -f "$STATE_FILE"
        exit 0
    fi
fi

# Single press - copy immediately, no sleep
echo "$current_time" > "$STATE_FILE"
wtype -M ctrl -k c -m ctrl
