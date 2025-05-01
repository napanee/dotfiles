#!/bin/bash

sketchybar --add item vpn_status right \
           --set vpn_status update_freq=10 \
                 icon= \
                 icon.font="$FONT_FACE:Bold:20.0" \
                 icon.padding_right=9 \
                 icon.padding_left=10 \
                 icon.color=$COLOR_WARNING \
                 icon.highlight_color=$COLOR_SUCCESS \
                 padding_right=5 \
                 label.drawing=off \
                 script="$PLUGIN_DIR/vpn_status.sh" \
                 click_script="$PLUGIN_DIR/vpn_toggle.sh"
