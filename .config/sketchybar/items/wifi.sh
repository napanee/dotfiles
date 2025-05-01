#!/bin/bash

sketchybar --add item wifi right \
           --set wifi \
                 label.padding_right=10 \
                 icon.font="$FONT_FACE:Bold:20.0" \
                 icon.padding_right=10 \
                 icon.padding_left=10 \
                 icon.color=$COLOR_ALERT \
                 icon.highlight_color=$COLOR_SUCCESS \
                 padding_right=5 \
                 script="$PLUGIN_DIR/wifi.sh" \
           --subscribe wifi wifi_change
