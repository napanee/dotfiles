#!/bin/sh

# Bar Appearance
bar=(
  position=top
  notch_display_height=32
  height=30
  margin=0
  y_offset=0
  corner_radius=0
  padding_left=10
  padding_right=10
  blur_radius=30
  color=$COLOR_BAR_BACKGROUND_DEFAULT
)

# Default Item Styles
default=(
  padding_left=0
  padding_right=0
  background.height=24
  background.corner_radius=4
  background.color=$COLOR_ITEM_BACKGROUND_DEFAULT
  icon.font="$FONT_FACE:Bold:22.0"
  icon.color=$COLOR_WHITE
  icon.padding_left=4
  icon.padding_right=4
  label.font="$FONT_FACE:Bold:12.0"
  label.color=$COLOR_WHITE
  label.padding_left=4
  label.padding_right=4
)

# Spacer
SPACER=(
  label.drawing=off
  icon.drawing=off
  padding_left=2
  padding_right=2
  background.color=$TRANSPARENT
)
