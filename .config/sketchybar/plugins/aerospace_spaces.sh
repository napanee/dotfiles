#!/bin/bash

source "$CONFIG_DIR/config/config.sh"

SCREEN=$1
SPACE=$2
ACTIVE_SPACES=$(aerospace list-workspaces --monitor all --visible)

if [[ " ${ACTIVE_SPACES[@]} " =~ $SPACE ]]; then
  sketchybar --set "m${SCREEN}_space_${SPACE}" icon="${SPACE_ICONS_ACTIVE[$SPACE-1]}" background.drawing=on
else
  sketchybar --set "m${SCREEN}_space_${SPACE}" icon="${SPACE_ICONS_DEFAULT[$SPACE-1]}" background.drawing=off
fi
