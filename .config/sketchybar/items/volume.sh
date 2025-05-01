#!/bin/bash

sketchybar --add item volume right \
           --set volume \
                 icon.font="$FONT_FACE:Bold:18.0" \
                 icon.padding_left=10 \
                 label.padding_right=10 \
                 padding_right=5 \
                 script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change
