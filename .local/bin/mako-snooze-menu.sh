#!/bin/bash
echo "script triggered at $(date)" >> /tmp/mako-snooze.log

NOTIF=$(makoctl list | awk '
/^Notification [0-9]+:/ { id=$2; gsub(/:/, "", id); summary=$0; gsub(/^Notification [0-9]+: /, "", summary) }
/App name:/ { app=$0; gsub(/^  App name: /, "", app) }
END { print id "|" app "|" summary }
')

ID=$(echo "$NOTIF" | cut -d'|' -f1)
APP=$(echo "$NOTIF" | cut -d'|' -f2)
SUMMARY=$(echo "$NOTIF" | cut -d'|' -f3)

if [ "$APP" = "Chromium" ]; then
    case "$SUMMARY" in
        *"outlook"*|*"Outlook"*|*"mail"*|*"Mail"*|*"message"*) APP="Outlook" ;;
        *"Teams"*|*"teams"*|*"meeting"*|*"Meeting"*)            APP="Teams" ;;
        *"Calendar"*|*"calendar"*)                               APP="Calendar" ;;
        *)                                                        APP="Chromium" ;;
    esac
fi

DELAY=$(printf "10 sec\n5 min\n10 min\n15 min\n30 min\n1 hour" | rofi -dmenu -p "Snooze for:" -theme-str '
window { width: 250px; border-radius: 8px; background-color: #282828; border-color: #7daea3; border: 2px; }
mainbox { padding: 8px; spacing: 0; }
inputbar { padding: 6px 8px; background-color: #3c3836; text-color: #d4be98; border-radius: 4px; margin: 0 0 6px 0; }
prompt { text-color: #7daea3; }
listview { lines: 6; spacing: 4px; }
element { padding: 4px 8px; border-radius: 4px; text-color: #d4be98; background-color: transparent; }
element selected { background-color: #504945; text-color: #a9b665; }
')

case "$DELAY" in
    "10 sec")  (sleep 10s && notify-send -a "$APP" "⏰ $APP" "$SUMMARY" -c snooze) & ;;
    "5 min")   (sleep 5m  && notify-send -a "$APP" "⏰ $APP" "$SUMMARY" -c snooze) & ;;
    "10 min")  (sleep 10m && notify-send -a "$APP" "⏰ $APP" "$SUMMARY" -c snooze) & ;;
    "15 min")  (sleep 15m && notify-send -a "$APP" "⏰ $APP" "$SUMMARY" -c snooze) & ;;
    "30 min")  (sleep 30m && notify-send -a "$APP" "⏰ $APP" "$SUMMARY" -c snooze) & ;;
    "1 hour")  (sleep 1h  && notify-send -a "$APP" "⏰ $APP" "$SUMMARY" -c snooze) & ;;
    *)         exit 0 ;;
esac

makoctl dismiss --id "$ID" 2>/dev/null || makoctl dismiss
disown
