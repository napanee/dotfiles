#!/bin/bash

IP_ADDRESS="$(ipconfig getsummary en0 | grep -o 'yiaddr = .*' | sed 's/^yiaddr = //')"

sketchybar --set "$NAME" label="$IP_ADDRESS"
