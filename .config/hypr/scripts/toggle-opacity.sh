#!/bin/bash

STATE_FILE="$HOME/.config/hypr/.opacity_state"

# Opacity levels (active/inactive pairs)
declare -A LEVELS=(
    [1_active]="1.0"
    [1_inactive]="1.0"
    [1_name]="Full Opacity"
    
    [2_active]="1.0"
    [2_inactive]="0.7"
    [2_name]="Inactive Dimmed (0.7)"
    
    [3_active]="1.0"
    [3_inactive]="0.3"
    [3_name]="Inactive Low (0.3)"
    
    [4_active]="1.0"
    [4_inactive]="1.0"
    [4_name]="Full Opacity"
)

# Initialize state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
    echo "1" > "$STATE_FILE"
fi

# Read current state
CURRENT_STATE=$(cat "$STATE_FILE")

# Calculate next state (cycle 1->2->3->4->1)
NEXT_STATE=$(( (CURRENT_STATE % 4) + 1 ))

# Apply opacity settings
ACTIVE_OPACITY="${LEVELS[${NEXT_STATE}_active]}"
INACTIVE_OPACITY="${LEVELS[${NEXT_STATE}_inactive]}"
LEVEL_NAME="${LEVELS[${NEXT_STATE}_name]}"

hyprctl keyword decoration:active_opacity "$ACTIVE_OPACITY"
hyprctl keyword decoration:inactive_opacity "$INACTIVE_OPACITY"

# Save new state
echo "$NEXT_STATE" > "$STATE_FILE"

# Send notification
notify-send -t 2000 "Opacity Level" "$LEVEL_NAME\nActive: $ACTIVE_OPACITY | Inactive: $INACTIVE_OPACITY"
