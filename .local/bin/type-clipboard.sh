#!/bin/bash
sleep 0.5
wl-paste | tr '@"' '"@' | ydotool type --delay 1 --file -
