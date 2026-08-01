if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && command -v startx >/dev/null 2>&1; then
  exec startx
fi
