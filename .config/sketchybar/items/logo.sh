#!/bin/sh

logo=(
  background.color=$COLOR_BRAND
  icon=
  icon.y_offset=2
  icon.font="$FONT_FACE:Bold:18.0"
  icon.padding_left=8
  icon.padding_right=8
  label.drawing=off
  display=1
)
sketchybar --add item logo left \
           --set logo "${logo[@]}"

sketchybar --add item logo_spacer left \
           --set logo_spacer "${SEPARATOR[@]}" display=1
