#!/bin/bash

sketchybar --add item time right \
           --set time update_freq=1 \
                 background.color=$COLOR_TRANSPARENT \
                 icon= \
                 label.padding_right=10 \
                 script="$PLUGIN_DIR/time.sh"

sketchybar --add item date right \
           --set date update_freq=30 \
                 background.color=$COLOR_TRANSPARENT \
                 icon="󰸗" \
                 icon.padding_left=10 \
                 icon.font="$FONT_FACE:Bold:16.0" \
                 script="$PLUGIN_DIR/date.sh"

sketchybar --add bracket bracket_datetime date time \
           --set bracket_datetime \
                 background.padding_left=20 \
                 background.padding_right=20
