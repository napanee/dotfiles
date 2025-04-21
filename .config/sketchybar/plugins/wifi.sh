#!/bin/bash

IP="$(ipconfig getsummary en0 | grep -o "yiaddr = .*" | sed 's/^yiaddr = //')"
SSID="$(ipconfig getsummary en0 | awk -F': ' '/  SSID :/ {print $2}')"

ICON=󰖪
HIGHLIGHT=off

if [ -n "$IP" ]; then
    ICON=󱚽
    HIGHLIGHT=on
fi

sketchybar --set $NAME label=$SSID icon=$ICON icon.highlight=$HIGHLIGHT
