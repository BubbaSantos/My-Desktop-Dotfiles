#!/bin/sh
# Keep the active floating window fully on its monitor's usable area.
# Shrinks it if larger than the area, then nudges it back inside.
# With "center" as $1, also centres it in the usable area.
set -eu
win="$(hyprctl activewindow -j)"
mon_id="$(printf "%s" "$win" | jq -r '.monitor')"
mon="$(hyprctl monitors -j | jq -c ".[] | select(.id == $mon_id)")"
# usable area = monitor minus reserved [left, top, right, bottom]
ax=$(printf "%s" "$mon" | jq '.x + .reserved[0]')
ay=$(printf "%s" "$mon" | jq '.y + .reserved[1]')
aw=$(printf "%s" "$mon" | jq '(.width / .scale | floor) - .reserved[0] - .reserved[2]')
ah=$(printf "%s" "$mon" | jq '(.height / .scale | floor) - .reserved[1] - .reserved[3]')
gap=10
aw=$((aw - 2*gap)); ah=$((ah - 2*gap)); ax=$((ax + gap)); ay=$((ay + gap))

ww=$(printf "%s" "$win" | jq '.size[0]'); wh=$(printf "%s" "$win" | jq '.size[1]')
wx=$(printf "%s" "$win" | jq '.at[0]');   wy=$(printf "%s" "$win" | jq '.at[1]')

[ "$ww" -gt "$aw" ] && nw=$aw || nw=$ww
[ "$wh" -gt "$ah" ] && nh=$ah || nh=$wh
[ "$nw" != "$ww" ] || [ "$nh" != "$wh" ] && hyprctl dispatch resizeactive exact "$nw" "$nh" >/dev/null

if [ "${1:-}" = center ]; then
  nx=$((ax + (aw - nw) / 2)); ny=$((ay + (ah - nh) / 2))
else
  nx=$wx; ny=$wy
  [ "$nx" -lt "$ax" ] && nx=$ax
  [ "$ny" -lt "$ay" ] && ny=$ay
  [ $((nx + nw)) -gt $((ax + aw)) ] && nx=$((ax + aw - nw))
  [ $((ny + nh)) -gt $((ay + ah)) ] && ny=$((ay + ah - nh))
fi
hyprctl dispatch moveactive exact "$nx" "$ny" >/dev/null
