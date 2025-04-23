#!/bin/sh

# Front App Name
front_app_name=(
  background.color=$COLOR_TRANSPARENT
  icon.drawing=off
  label.color=$COLOR_WHITE
  label.padding_left=10
  label.padding_right=10
)
sketchybar --add item front_app.name q \
           --set front_app.name "${front_app_name[@]}"

# Front App Icon
front_app=(
  background.color=$COLOR_BRAND
  icon.padding_left=10
  icon.padding_right=10
  label.drawing=off
  script="$PLUGIN_DIR/front_app.sh"
)
sketchybar --add item front_app q \
           --set front_app "${front_app[@]}"

# Bracket für Front App
sketchybar --add bracket bracket_front_app front_app front_app.name \
           --subscribe front_app front_app_switched
