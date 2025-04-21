#!/bin/sh

source "$CONFIG_DIR/config/colors.sh"

if [ "$MODE" = "service" ]; then
  sketchybar --set "$NAME" background.color=$COLOR_HIGHLIGHT icon.color=$COLOR_BLACK
else
  sketchybar --set "$NAME" background.color=$COLOR_ITEM_BACKGROUND_DEFAULT icon.color=$COLOR_WHITE
fi
