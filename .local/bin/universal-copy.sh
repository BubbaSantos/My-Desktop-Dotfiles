#!/usr/bin/env bash
# Universal copy: Ctrl+Insert works in terminals too (unlike Ctrl+C, which sends SIGINT there).
# QuickShell popups are layer surfaces that sendshortcut can't reach, so let QuickShell
# copy from its own focused text field first.
if [[ $(qs ipc -c "QuickShell Bar" call clipboard universalCopy 2>/dev/null) == true ]]; then
  exit 0
fi
hyprctl dispatch sendshortcut "CTRL, Insert, activewindow"
qs ipc -c "QuickShell Bar" call clipboard showCopied
