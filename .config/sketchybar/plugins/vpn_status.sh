#!/bin/sh

STATUS="$(/opt/cisco/secureclient/bin/vpn state | grep 'Connected')"
ICON=""
HIGHLIGHT=off

if [[ "$STATUS" != "" ]]; then
  ICON=""
  HIGHLIGHT=on
fi

sketchybar --set "$NAME" icon="$ICON" icon.highlight="$HIGHLIGHT"
