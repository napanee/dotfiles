#!/bin/sh
#
# Dynamische Monitor-Erkennung anhand der EDID-Seriennummern.
# Funktioniert unabhängig davon, welcher Output-Name zugewiesen wird.
#

LAYOUT_DIR="$HOME/.screenlayout"

# --- Konfiguration: Seriennummern der bekannten Monitore ---
# Dell U3225QE (Primary, 4K)
SERIAL_PRIMARY="D02G684"
# Dell U2723QE (Portrait, 4K)
SERIAL_PORTRAIT="C55F2H3"

# --- Hilfsfunktion: Output-Name für eine Seriennummer finden ---
get_output_for_serial() {
    target_serial="$1"
    python3 -c "
import subprocess, re, sys

target = sys.argv[1]
output_text = subprocess.check_output(['xrandr', '--props'], text=True)

current_output = None
edid_lines = []
collecting_edid = False

for line in output_text.splitlines():
    m = re.match(r'^(\S+)\s+connected', line)
    if m:
        current_output = m.group(1)
        collecting_edid = False
        continue

    if 'EDID:' in line:
        collecting_edid = True
        edid_lines = []
        continue

    if collecting_edid:
        stripped = line.strip()
        if re.match(r'^[0-9a-f]+$', stripped):
            edid_lines.append(stripped)
        else:
            collecting_edid = False
            edid_hex = ''.join(edid_lines)
            edid_bytes = bytes.fromhex(edid_hex)
            for i in range(54, min(126, len(edid_bytes)), 18):
                block = edid_bytes[i:i+18]
                if len(block) >= 18 and block[0:3] == b'\x00\x00\x00' and block[3] == 0xFF:
                    serial = block[5:18].decode('ascii', errors='replace').strip()
                    if serial == target:
                        print(current_output)
                        sys.exit(0)
" "$target_serial"
}

# --- Erkennung ---
OUTPUT_PRIMARY=$(get_output_for_serial "$SERIAL_PRIMARY")
OUTPUT_PORTRAIT=$(get_output_for_serial "$SERIAL_PORTRAIT")

# Hat das System ein eingebautes Display (Laptop)?
HAS_INTERNAL=$(xrandr --query | grep "^eDP" | grep " connected" | awk '{print $1}')

if [ -n "$OUTPUT_PRIMARY" ] && [ -n "$OUTPUT_PORTRAIT" ] && [ -z "$HAS_INTERNAL" ]; then
    # Fall 1: Desktop – beide externe Monitore, kein internes Display
    # Alle Outputs abschalten, die nicht gebraucht werden
    ALL_OUTPUTS=$(xrandr --query | grep " connected\| disconnected" | awk '{print $1}')
    OFF_ARGS=""
    for out in $ALL_OUTPUTS; do
        if [ "$out" != "$OUTPUT_PRIMARY" ] && [ "$out" != "$OUTPUT_PORTRAIT" ]; then
            OFF_ARGS="$OFF_ARGS --output $out --off"
        fi
    done
    xrandr --output "$OUTPUT_PRIMARY" --primary --mode 3840x2160 --pos 2160x840 --rotate normal \
           --output "$OUTPUT_PORTRAIT" --mode 3840x2160 --pos 0x0 --rotate left \
           $OFF_ARGS

elif [ -n "$OUTPUT_PRIMARY" ] && [ -n "$OUTPUT_PORTRAIT" ] && [ -n "$HAS_INTERNAL" ]; then
    # Fall 2: Laptop mit beiden externen Monitoren
    ALL_OUTPUTS=$(xrandr --query | grep " connected\| disconnected" | awk '{print $1}')
    OFF_ARGS=""
    for out in $ALL_OUTPUTS; do
        if [ "$out" != "$OUTPUT_PRIMARY" ] && [ "$out" != "$OUTPUT_PORTRAIT" ] && [ "$out" != "$HAS_INTERNAL" ]; then
            OFF_ARGS="$OFF_ARGS --output $out --off"
        fi
    done
    xrandr --output "$HAS_INTERNAL" --mode 1920x1080 --pos 6000x2185 --rotate normal \
           --output "$OUTPUT_PORTRAIT" --mode 3840x2160 --pos 0x0 --rotate left \
           --output "$OUTPUT_PRIMARY" --primary --mode 3840x2160 --pos 2160x840 --rotate normal \
           $OFF_ARGS

elif [ -n "$HAS_INTERNAL" ]; then
    # Fall 3: Laptop ohne externe Monitore
    ALL_OUTPUTS=$(xrandr --query | grep " connected\| disconnected" | awk '{print $1}')
    OFF_ARGS=""
    for out in $ALL_OUTPUTS; do
        if [ "$out" != "$HAS_INTERNAL" ]; then
            OFF_ARGS="$OFF_ARGS --output $out --off"
        fi
    done
    xrandr --output "$HAS_INTERNAL" --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           $OFF_ARGS
fi

# --- DPI auf 96 setzen (verhindert zu große UI-Elemente auf 4K) ---
xrandr --dpi 96

# --- Qt-Skalierung deaktivieren ---
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1

# --- Qtile Config neu laden ---
qtile cmd-obj -o cmd -f reload_config 2>/dev/null
