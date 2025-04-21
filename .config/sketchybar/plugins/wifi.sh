#!/bin/bash

IP="$(ipconfig getsummary en0 | grep -o "yiaddr = .*" | sed 's/^yiaddr = //')"

ICON=󰖪
HIGHLIGHT=off

if [ -n "$IP" ]; then
    ICON=󱚽
    HIGHLIGHT=on
fi

sketchybar --set $NAME icon=$ICON icon.highlight=$HIGHLIGHT
