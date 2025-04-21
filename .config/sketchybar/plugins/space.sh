#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

sketchybar --set "$NAME" background.drawing="$SELECTED" label="${DID}_${SID}"

ICONS_DEFAULT=("" "" "" "" "" "" "" "" "")
ICONS_ACTIVE=("" "" "" "" "" "" "" "" "")

if [ "$SELECTED" = true ]; then
  sketchybar --set "$NAME" icon="${ICONS_ACTIVE[$SID-1]}"
else
  sketchybar --set "$NAME" icon="${ICONS_DEFAULT[$SID-1]}"
fi
