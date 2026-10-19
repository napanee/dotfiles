[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:${PATH}"

export PATH

if [ "$(tty)" = "/dev/tty1" ] && command -v Hyprland >/dev/null 2>&1; then
  exec Hyprland
fi
