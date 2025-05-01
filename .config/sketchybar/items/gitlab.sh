#!/bin/sh

BASE=(
  background.color=$COLOR_TRANSPARENT
  icon.padding_left=5
  icon.padding_right=0
  label.padding_left=2
  label.padding_right=5
)

# Icon
gitlab=(
  background.color=$COLOR_BRAND
  icon=
  icon.padding_left=10
  icon.padding_right=10
  label.drawing=off
)
sketchybar --add item gitlab e \
           --set gitlab "${gitlab[@]}" \
                 update_freq=10 \
                 script="$PLUGIN_DIR/gitlab.sh" \
                 click_script="sketchybar -m --set \$NAME popup.drawing=toggle" \
                 popup.background.border_width=2 \
                 popup.background.corner_radius=3 \
                 popup.background.border_color=0xff9dd274

sketchybar --add item apple.preferences popup.gitlab \
           --set apple.preferences icon=􀺽 \
                 label="Preferences" \
                 click_script="open -a 'System Preferences'; sketchybar -m --set apple.logo popup.drawing=off"

# Name
gitlab_info_approved=(
  "${BASE[@]}"
  icon=
  icon.color=$COLOR_SUCCESS
  label="1"
)
sketchybar --add item gitlab.approved e \
           --set gitlab.approved "${gitlab_info_approved[@]}"

gitlab_info_notapproved=(
  "${BASE[@]}"
  icon=
  icon.color=$COLOR_ALERT
  label="0"
)
sketchybar --add item gitlab.notapproved e \
           --set gitlab.notapproved "${gitlab_info_notapproved[@]}"

gitlab_info_others=(
  "${BASE[@]}"
  icon=
  icon.color=$COLOR_WHITE
  label="4"
)
sketchybar --add item gitlab.others e \
           --set gitlab.others "${gitlab_info_others[@]}"

# Bracket for Gitlab
sketchybar --add bracket bracket_gitlab gitlab gitlab.approved gitlab.notapproved gitlab.others
