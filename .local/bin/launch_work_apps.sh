#!/bin/bash

# --- Workspace 1 ---
hyprctl dispatch workspace 1
sleep 0.5

# Launch main apps
~/.local/bin/toggle-vivaldi.sh &
sleep 2  # give Vivaldi time to start

~/.local/bin/toggle-chatgpt.sh &
sleep 2  # wait for ChatGPT

# Start grouping
ydotool key super+g
sleep 0.5

# Launch grouped apps
~/.local/bin/toggle-claude.sh &
sleep 1
~/.local/bin/toggle-to-do.sh &
sleep 1

# --- Workspace 2 ---
hyprctl dispatch workspace 2
sleep 0.5
~/.local/bin/toggle-outlook.sh &
sleep 2
~/.local/bin/toggle-chatgpt.sh &
sleep 2
ydotool key super+g
sleep 0.5
~/.local/bin/toggle-to-do.sh &
sleep 1
~/.local/bin/toggle-teams.sh &
sleep 2

# --- Workspace 3 ---
hyprctl dispatch workspace 3
sleep 0.5
# Launch a separate Teams instance via your launcher
hyprctl dispatch exec "Teams" 
sleep 2

# --- Workspace 6 ---
hyprctl dispatch workspace 6
sleep 0.5
~/.local/bin/toggle-notion.sh &
sleep 2
