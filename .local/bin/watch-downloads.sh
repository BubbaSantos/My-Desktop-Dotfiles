#!/usr/bin/env bash
inotifywait -m -e close_write,moved_to ~/Downloads |
while read -r dir event file; do
    python3 -c "
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
rm = Gtk.RecentManager.get_default()
rm.add_item('file://${dir}${file}')
"
done
