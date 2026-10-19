[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:${PATH}"

export PATH

if [ "$(tty)" = "/dev/tty1" ]; then
  # start-hyprland ist der empfohlene Watchdog-Wrapper. Direkter Aufruf von
  # Hyprland loest die Warnung "started without start-hyprland" aus; daher
  # bevorzugt den Wrapper, mit Fallback auf das nackte Binary.
  if command -v start-hyprland >/dev/null 2>&1; then
    exec start-hyprland
  elif command -v Hyprland >/dev/null 2>&1; then
    exec Hyprland
  fi
fi
