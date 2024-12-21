#!/bin/bash

# Get out of town if something errors
#set -e

# echo "start" | systemd-cat -t screen_detection -p info
echo "change detected" | systemd-cat -t screen_detection -p info

card=""
if [ -d "/sys/class/drm/card0" ]; then
    card=card0
else
    card=card1
fi

# connected_screens=$(xrandr | grep -w 'connected' | cut -d ' ' -f 2 | wc -l)
# echo "${connected_screens} screens connected"

if
    [ ! -d "/sys/class/drm/$card/$card-DP-2" ] || [ ! -d "/sys/class/drm/$card/$card-DP-4" ] &&
    [ ! -d "/sys/class/drm/$card/$card-DP-1" ] || [ ! -d "/sys/class/drm/$card/$card-DP-4" ]; then
    echo "not two screens connected" | systemd-cat -t screen_detection -p info
    exit 0
fi

echo "both screens available" | systemd-cat -t screen_detection -p info

USB_1_STATUS=$(</sys/class/drm/$card/$card-DP-2/status ) # 29"
USB_2_STATUS=$(</sys/class/drm/$card/$card-DP-4/status ) # 32"

if [ "connected" == "$USB_1_STATUS" ] && [ "connected" == "$USB_2_STATUS" ]; then
	echo "both screens connected" | systemd-cat -t screen_detection -p info

	echo "activation start" | systemd-cat -t screen_detection -p info

	/usr/bin/xrandr \
	--output eDP-1 --mode 1920x1080 --pos 6000x1868 --rotate normal \
	--output DP-2 --mode 3840x2160 --pos 0x0 --rotate left \
	--output DP-1-8 --primary --mode 3840x2160 --pos 2160x958 --rotate normal

	echo "activation end" | systemd-cat -t screen_detection -p info
else
	/usr/bin/xrandr \
	--output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
	--output DP-2 --off \
	--output DP-1-8 --off

	echo "USB device removed  at $(date)" >>/tmp/scripts.log
fi
