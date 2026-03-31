#!/bin/bash
# Debug version to see what's happening

LOGFILE="/tmp/espanso-restart.log"

echo "=== Restart attempt at $(date) ===" >> "$LOGFILE"

# Kill espanso
echo "Killing espanso..." >> "$LOGFILE"
pkill -f espanso
echo "Kill exit code: $?" >> "$LOGFILE"

# Wait for clean shutdown
sleep 0.5

# Check if espanso is actually dead
echo "Checking if espanso is dead..." >> "$LOGFILE"
pgrep -f espanso >> "$LOGFILE"
echo "pgrep exit code: $?" >> "$LOGFILE"

# Try to start espanso and capture any errors
echo "Starting espanso..." >> "$LOGFILE"
espanso start >> "$LOGFILE" 2>&1 &
START_PID=$!
echo "Start command PID: $START_PID" >> "$LOGFILE"

# Wait a moment and check if it's running
sleep 1
echo "Checking if espanso started..." >> "$LOGFILE"
pgrep -f espanso >> "$LOGFILE"
echo "Final pgrep exit code: $?" >> "$LOGFILE"

# Check espanso status
echo "Espanso status:" >> "$LOGFILE"
espanso status >> "$LOGFILE" 2>&1

echo "=== End ===" >> "$LOGFILE"
