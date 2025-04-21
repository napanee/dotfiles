#!/bin/sh

# Clock
sketchybar --add item time right \
           --set time update_freq=1 \
                 background.color=0x00000000 \
                 icon= \
                 label.padding_right=10 \
                 script="$PLUGIN_DIR/time.sh"

# Date
sketchybar --add item date right \
           --set date update_freq=30 \
                 background.color=0x00000000 \
                 icon="󰸗" \
                 icon.padding_left=10 \
                 icon.font="$FONT_FACE:Bold:16.0" \
                 script="$PLUGIN_DIR/date.sh"

# Bracket for Date & Clock
sketchybar --add bracket bracket_datetime date time \
           --set bracket_datetime \
                 background.padding_left=20 \
                 background.padding_right=20

# Volume
sketchybar --add item volume right \
           --set volume \
                 icon.font="$FONT_FACE:Bold:18.0" \
                 icon.padding_left=10 \
                 label.padding_right=10 \
                 padding_right=5 \
                 script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change

# Battery
sketchybar --add item battery right \
           --set battery update_freq=120 \
                 icon.font="$FONT_FACE:Bold:14.0" \
                 icon.padding_left=10 \
                 label.padding_right=10 \
                 padding_right=5 \
                 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change

# WIFI
sketchybar --add item wifi right \
           --set wifi \
                 icon.font="$FONT_FACE:Bold:20.0" \
                 icon.padding_right=9 \
                 icon.padding_left=10 \
                 icon.color=0xffd0021b \
                 icon.highlight_color=0xff7ed321 \
                 padding_right=5 \
                 label.drawing=off \
                 script="$PLUGIN_DIR/wifi.sh"\
           --subscribe wifi wifi_change \

# VPN Connecttion
sketchybar --add item vpn_status right \
           --set vpn_status update_freq=10 \
                 icon.font="$FONT_FACE:Bold:20.0" \
                 icon.padding_right=9 \
                 icon.padding_left=10 \
                 icon.color=0xffd0021b \
                 icon.highlight_color=0xff7ed321 \
                 padding_right=5 \
                 label.drawing=off \
                 script="$PLUGIN_DIR/vpn_status.sh"
