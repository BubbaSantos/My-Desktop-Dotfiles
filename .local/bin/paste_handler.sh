#!/usr/bin/env bash
# Same universal paste as Super+V, bound separately to Ctrl+backtick.
hyprctl dispatch sendshortcut "SHIFT, Insert, activewindow"
qs ipc -c "QuickShell Bar" call clipboard showPasted
