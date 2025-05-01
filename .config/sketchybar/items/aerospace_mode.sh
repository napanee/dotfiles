#!/bin/bash

sketchybar --add event aerospace_mode
sketchybar --add item aerospace_mode right \
           --set aerospace_mode \
                 icon="󰰡" \
                 label.drawing=off \
                 icon.padding_right=10 \
                 icon.padding_left=10 \
                 padding_right=5 \
                 script="$PLUGIN_DIR/aerospace_mode.sh" \
           --subscribe aerospace_mode aerospace_mode
