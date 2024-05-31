#displayCount=xrandr -q | grep " connected" | wc -l
#sleep 1.5
#xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-3 --off --output HDMI-3 --off
#xrandr --output eDP-1 --mode 1920x1080 --pos 6000x1868 --rotate normal --output DP-1 --off --output HDMI-1 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate left --output HDMI-2 --off --output DP-3 --off --output HDMI-3 --off --output DP-1-8 --primary --mode 3840x2160 --pos 2160x958 --rotate normal --output DP-1-1 --off

autostart &

exec qtile start
