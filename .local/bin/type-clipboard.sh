#!/bin/bash
sleep 0.5
wl-paste | tr '@"' '"@' | ydotool type --delay 1 --file -
qs ipc -c "QuickShell Bar" call clipboard showTyped
