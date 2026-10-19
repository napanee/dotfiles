#!/bin/sh

# Wird von qtile via @hook.subscribe.startup_once gestartet, also erst
# nachdem der WM vollständig initialisiert ist. Kein sleep-Workaround nötig.

# set cursor-size
xrdb ~/.Xresources

# keymapping
# setxkbmap -option ctrl:swap_lalt_lctl &
#[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# display setup
display_env

# compositor (blur, transparency, shadows)
picom &

# notification daemon
dunst &

copyq &

enpass &

nextcloud &

numlockx &

# --- Screen Lock & Power Management ---
# xidlehook handles fullscreen detection, lock, dpms, and suspend.
xset -dpms
xset s off

# test which app plays audio:
# timeout 1 pw-cat --record --target 0 /dev/null --format f32 2>/dev/null; \
# pactl list sink-inputs | grep -E 'Corked:|media.name'
xidlehook \
	--not-when-audio \
	--timer 600 'lock' '' \
	--timer 300 'systemctl suspend' '' &
