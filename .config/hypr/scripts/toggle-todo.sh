#!/bin/bash

# Check if To Do is already running
if hyprctl clients | grep -q "chrome-to-do.office.com__-Profile_1"; then
    # Toggle the special workspace
    hyprctl dispatch togglespecialworkspace todo
else
    # Launch To Do in the special workspace
    hyprctl dispatch exec "[workspace special:todo]" "google-chrome-stable --profile-directory='Profile 1' --app=https://to-do.office.com/"
    sleep 0.5
    hyprctl dispatch togglespecialworkspace todo
fi
