#!/bin/bash

# --- Workspace 1 ---
hyprctl dispatch workspace 1
sleep 0.5

# Launch main apps
~/.config/hypr/scripts/toggle-vivaldi.sh &
sleep 2  # give Vivaldi time to start

~/.config/hypr/scripts/toggle-chatgpt.sh &
sleep 2  # wait for ChatGPT

# Start grouping
ydotool key super+g
sleep 0.5

# Launch grouped apps
~/.config/hypr/scripts/toggle-claude.sh &
sleep 1
~/.config/hypr/scripts/toggle-to-do.sh &
sleep 1

# --- Workspace 2 ---
hyprctl dispatch workspace 2
sleep 0.5
~/.config/hypr/scripts/toggle-outlook.sh &
sleep 2
~/.config/hypr/scripts/toggle-chatgpt.sh &
sleep 2
ydotool key super+g
sleep 0.5
~/.config/hypr/scripts/toggle-to-do.sh &
sleep 1
~/.config/hypr/scripts/toggle-teams.sh &
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
~/.config/hypr/scripts/toggle-notion.sh &
sleep 2
