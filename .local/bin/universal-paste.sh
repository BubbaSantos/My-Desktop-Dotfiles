#!/usr/bin/env bash
# Universal paste: Shift+Insert works in terminals too (unlike Ctrl+V).
hyprctl dispatch sendshortcut "SHIFT, Insert, activewindow"
qs ipc -c "QuickShell Bar" call clipboard showPasted
