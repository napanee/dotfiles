#!/usr/bin/env bash
# Gibt das aktuelle Tiling-Layout des aktiven Workspace als Waybar-JSON aus.
# Hyprland liefert es in activeworkspace.tiledLayout (z.B. "master", "monocle").
#
# Ausgabe: {text, tooltip, class} (return-type: json).

layout="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.tiledLayout // "master"')"

case "$layout" in
    monocle)
        printf '{"text":"󰊓","tooltip":"Monocle","class":"monocle"}\n'
        ;;
    master)
        printf '{"text":"󰙀","tooltip":"Master","class":"master"}\n'
        ;;
    *)
        # Fallback fuer andere Layouts (dwindle, scrolling, ...).
        printf '{"text":"","tooltip":"%s","class":"other"}\n' "$layout"
        ;;
esac
