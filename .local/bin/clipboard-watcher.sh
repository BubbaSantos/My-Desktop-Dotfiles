#!/usr/bin/env bash
# ~/.local/bin/clipboard-watcher.sh

CACHE_DIR=/tmp/handy-clipboard-cache
mkdir -p "$CACHE_DIR"

wl-paste --watch sh -c '
    CACHE_DIR=/tmp/handy-clipboard-cache
    # Get the preferred MIME type (first in the list)
    mime=$(wl-paste --list-types 2>/dev/null | head -1)
    [ -z "$mime" ] && exit 0
    
    # Save the type and content
    echo "$mime" > "$CACHE_DIR/type"
    wl-paste --type "$mime" > "$CACHE_DIR/content" 2>/dev/null
'
