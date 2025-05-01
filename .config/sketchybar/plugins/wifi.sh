#!/bin/bash

IP="$(ipconfig getsummary en0 | grep -o "yiaddr = .*" | sed 's/^yiaddr = //')"
SSID="$(ipconfig getsummary en0 | awk -F': ' '/  SSID :/ {print $2}')"

ICON=󰖪
HIGHLIGHT=off
SHOW_LABEL=off

if [ -n "$IP" ]; then
    ICON=󱚽
    HIGHLIGHT=on
    SHOW_LABEL=on
fi

sketchybar --set $NAME label.drawing=$SHOW_LABEL label="${SSID} (${IP})" icon=$ICON icon.highlight=$HIGHLIGHT
