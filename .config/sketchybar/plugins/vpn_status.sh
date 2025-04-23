#!/bin/sh

source "$CONFIG_DIR/config/colors.sh"

STATUS="$(/opt/cisco/secureclient/bin/vpn state | grep 'Connected')"
ICON=""
COLOR=$COLOR_ALERT

if [[ "$STATUS" != "" ]]; then
  ICON=""
  COLOR=$COLOR_SUCCESS
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
