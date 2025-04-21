#!/bin/sh

# Spacer vor dem Front App Icon
SPACER_FRONT_APP_LEFT=(
  "${SPACER[@]}"
  display=1
  padding_left=0
  padding_right=0
)
sketchybar --add item spacer_front_app_left left \
           --set spacer_front_app_left "${SPACER_FRONT_APP_LEFT[@]}"

# Front App Icon
front_app=(
  background.color=$COLOR_BRAND
  icon.padding_left=10
  icon.padding_right=10
  label.drawing=off
  script="$PLUGIN_DIR/front_app.sh"
  display=1
)
sketchybar --add item front_app left \
           --set front_app "${front_app[@]}"

# Front App Name
front_app_name=(
  background.color=$COLOR_TRANSPARENT
  icon.drawing=off
  label.color=$COLOR_WHITE
  label.padding_left=10
  label.padding_right=10
  display=1
)
sketchybar --add item front_app.name left \
           --set front_app.name "${front_app_name[@]}"

# Bracket für Front App
sketchybar --add bracket bracket_front_app front_app front_app.name \
           --subscribe front_app front_app_switched
