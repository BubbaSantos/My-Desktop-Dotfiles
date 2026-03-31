#!/bin/bash
# Work Workflow Script - Complete Layout
# Opens applications in designated workspaces with grouping

# Function to wait for a window with specific class to appear
wait_for_window() {
    local class_pattern="$1"
    local max_wait=10
    local count=0
    
    while [ $count -lt $max_wait ]; do
        if hyprctl clients | grep -q "$class_pattern"; then
            return 0
        fi
        sleep 0.5
        ((count++))
    done
    return 1
}

# Function to get window address by class pattern
get_window_address() {
    local class_pattern="$1"
    hyprctl clients -j | jq -r ".[] | select(.class | test(\"$class_pattern\")) | .address" | head -n1
}

# Function to create a group by focusing windows in sequence
create_group() {
    local workspace="$1"
    shift
    local addresses=("$@")
    
    if [ ${#addresses[@]} -lt 2 ]; then
        return
    fi
    
    hyprctl dispatch workspace "$workspace"
    sleep 0.2
    
    # Focus first window
    hyprctl dispatch focuswindow "address:${addresses[0]}"
    sleep 0.1
    
    # Add remaining windows to group
    for addr in "${addresses[@]:1}"; do
        hyprctl dispatch focuswindow "address:$addr"
        sleep 0.1
        hyprctl dispatch togglegroup
        sleep 0.1
    done
}

# ========== WORKSPACE 1: Vivaldi + AI Tools (grouped) ==========
hyprctl dispatch workspace 1
vivaldi https://midaspro.mab.org.uk/Midas.Homepage/ &
wait_for_window "class.*vivaldi"
VIVALDI_ADDR=$(get_window_address "vivaldi")
sleep 0.5

# Launch ChatGPT PWA
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://chatgpt.com/" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome-chatgpt.com"
CHATGPT1_ADDR=$(get_window_address "chrome-chatgpt.com")
sleep 0.5

# Launch Claude PWA
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://claude.ai/new" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome-claude.ai"
CLAUDE1_ADDR=$(get_window_address "claude")
sleep 0.5

# Launch To Do PWA
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://to-do.office.com/tasks" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome-to-do.office.com"
TODO1_ADDR=$(get_window_address "to-do")
sleep 0.5

# Group ChatGPT, Claude, and To Do (leave Vivaldi separate)
if [ -n "$CHATGPT1_ADDR" ] && [ -n "$CLAUDE1_ADDR" ] && [ -n "$TODO1_ADDR" ]; then
    create_group "1" "$CHATGPT1_ADDR" "$CLAUDE1_ADDR" "$TODO1_ADDR"
fi

# ========== WORKSPACE 2: Outlook + AI Tools + Teams Chat (grouped) ==========
hyprctl dispatch workspace 2
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://outlook.office.com/mail" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome-outlook.office.com"
OUTLOOK_ADDR=$(get_window_address "outlook")
sleep 0.5

# Launch second set of AI tools
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://chatgpt.com/" --user-data-dir="$HOME/.config/chromium-profile1" &
sleep 2
CHATGPT2_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class | test("chatgpt")) | select(.workspace.id != 1) | .address' | head -n1)

uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://claude.ai/new" --user-data-dir="$HOME/.config/chromium-profile1" &
sleep 2
CLAUDE2_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class | test("claude")) | select(.workspace.id != 1) | .address' | head -n1)

uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://to-do.office.com/tasks" --user-data-dir="$HOME/.config/chromium-profile1" &
sleep 2
TODO2_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class | test("to-do")) | select(.workspace.id != 1) | .address' | head -n1)

# Launch Teams Chat
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://teams.microsoft.com/v2/" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome-teams.microsoft.com.*Profile"
TEAMS_CHAT_ADDR=$(get_window_address "teams.microsoft.com.*Profile")
sleep 0.5

# Group the AI tools and Teams Chat (leave Outlook separate)
GROUP2_ADDRS=()
[ -n "$CHATGPT2_ADDR" ] && GROUP2_ADDRS+=("$CHATGPT2_ADDR")
[ -n "$CLAUDE2_ADDR" ] && GROUP2_ADDRS+=("$CLAUDE2_ADDR")
[ -n "$TODO2_ADDR" ] && GROUP2_ADDRS+=("$TODO2_ADDR")
[ -n "$TEAMS_CHAT_ADDR" ] && GROUP2_ADDRS+=("$TEAMS_CHAT_ADDR")

if [ ${#GROUP2_ADDRS[@]} -ge 2 ]; then
    create_group "2" "${GROUP2_ADDRS[@]}"
fi

# ========== WORKSPACE 3: Teams Bookings + Terminal ==========
hyprctl dispatch workspace 3
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://teams.microsoft.com/v2/" --force-new-instance &
wait_for_window "chrome-teams.microsoft.com.*Default"
sleep 0.5

# Launch Ghostty terminal
ghostty &
wait_for_window "class.*ghostty"
sleep 0.1

# ========== WORKSPACE 6: Notion ==========
hyprctl dispatch workspace 6
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://www.notion.so/" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome.*notion"
sleep 0.1

# ========== SPECIAL WORKSPACE: X (Twitter) - Floating ==========
uwsm app -- chromium --new-window --ozone-platform=wayland --app="https://x.com/" --user-data-dir="$HOME/.config/chromium-profile1" &
wait_for_window "chrome-x.com"
X_ADDR=$(get_window_address "x.com")

if [ -n "$X_ADDR" ]; then
    hyprctl dispatch movetoworkspacesilent "special:x,address:$X_ADDR"
    sleep 0.3
    hyprctl dispatch togglefloating "address:$X_ADDR"
    sleep 0.2
    hyprctl dispatch resizewindowpixel "exact 592 730,address:$X_ADDR"
fi

# Return to workspace 1
hyprctl dispatch workspace 1

# Send notification
notify-send "Work Workflow" "All applications launched and organized" -t 3000
