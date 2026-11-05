#!/usr/bin/env bash
# Universal paste: Shift+Insert works in terminals too (unlike Ctrl+V).
# QuickShell popups are layer surfaces that sendshortcut can't reach, so let QuickShell
# paste into its own focused text field first.
if [[ $(qs ipc -c "QuickShell Bar" call clipboard universalPaste 2>/dev/null) == true ]]; then
  exit 0
fi
hyprctl dispatch sendshortcut "SHIFT, Insert, activewindow"
qs ipc -c "QuickShell Bar" call clipboard showPasted
