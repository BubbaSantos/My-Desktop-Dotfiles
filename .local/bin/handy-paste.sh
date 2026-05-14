#!/usr/bin/env bash
# ~/.local/bin/handy-paste.sh

text="$1"
[ -z "$text" ] && exit 0

CACHE_DIR=/tmp/handy-clipboard-cache
old_type=""
[ -f "$CACHE_DIR/type" ] && old_type="$(cat "$CACHE_DIR/type")"

# Set transcript as clipboard and paste
printf '%s' "$text" | wl-copy --sensitive >/dev/null 2>&1

sleep 0.05
wtype -M shift -k Insert -m shift
wtype -m shift -m ctrl -m alt -m logo

# Restore in background with correct MIME type
(
    sleep 0.2
    if [ -n "$old_type" ] && [ -f "$CACHE_DIR/content" ]; then
        wl-copy --type "$old_type" < "$CACHE_DIR/content" >/dev/null 2>&1
    else
        wl-copy --clear >/dev/null 2>&1
    fi
) </dev/null >/dev/null 2>&1 &
disown
