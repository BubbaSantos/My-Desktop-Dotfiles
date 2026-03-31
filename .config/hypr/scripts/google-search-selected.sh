#!/bin/bash
set -eu

# Get selected text
TEXT="$(wl-paste -p 2>/dev/null || true)"

# URL encode the text
ENCODED="$(printf "%s" "$TEXT" | jq -sRr @uri)"

# Build Google search URL
URL="https://www.google.com/search?q=$ENCODED"

# Open in default browser
xdg-open "$URL" >/dev/null 2>&1 &
