#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=120 \
                 icon.font="$FONT_FACE:Bold:14.0" \
                 icon.padding_left=10 \
                 label.padding_right=10 \
                 padding_right=5 \
                 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
