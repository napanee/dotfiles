#!/bin/sh

sketchybar --add item ip_address e \
           --set ip_address \
                 icon=󰩠 \
                 icon.padding_left=10 \
                 label.padding_right=10 \
                 padding_right=5 \
                 script="$CONFIG_DIR/plugins/ip_address.sh" \
                 click_script="$CONFIG_DIR/plugins/ip_address.sh"
