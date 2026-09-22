#!/usr/bin/env bash
# Universal copy: Ctrl+Insert works in terminals too (unlike Ctrl+C, which sends SIGINT there).
hyprctl dispatch sendshortcut "CTRL, Insert, activewindow"
qs ipc -c "QuickShell Bar" call clipboard showCopied
