#!/bin/bash

STATE_FILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/voxtype/state"

# Check if voxtype service is running
if ! systemctl --user is-active --quiet voxtype.service; then
    echo '{"text":"","class":"stopped","tooltip":"Voxtype: Stopped\n\nClick to start service"}'
    exit 0
fi

# Read state file
if [[ -f "$STATE_FILE" ]]; then
    STATE=$(cat "$STATE_FILE" 2>/dev/null)
else
    STATE="idle"
fi

case "$STATE" in
    recording)
        echo '{"text":"","class":"recording","tooltip":"Voxtype: Recording...\n\nClick to stop"}'
        ;;
    transcribing)
        echo '{"text":"󰔟","class":"transcribing","tooltip":"Voxtype: Transcribing..."}'
        ;;
    idle|*)
        echo '{"text":"","class":"idle","tooltip":"Voxtype: Ready\n\nClick to record"}'
        ;;
esac
