# Aufgabe: `~/.dotfiles` von X11 + qtile auf Wayland + minimales Hyprland migrieren

Repo: `~/.dotfiles` (remote `git@github.com:napanee/dotfiles.git`), verwaltet mit **dotbot** über `install.config.yml`. Wird von einem Ansible-Installer ausgerollt, der gerade von X11+qtile auf **Wayland + minimales Hyprland** umgestellt wurde. Diese Dotfiles müssen entsprechend nachziehen. Die Werte unten sind aus den **tatsächlichen** aktuellen Dateien gelesen.

> **Wichtig vorab:** Vor jedem Löschen/Ändern die betroffene Datei selbst nochmal lesen. Keinen Commit/Push ohne Rücksprache — Änderungen im Working Tree lassen. Die Entscheidungen in §0 sind verbindlich. Hyprland-Doku: https://wiki.hypr.land/Configuring/

---

## 0. Verbindliche Entscheidungen des Users (nicht erneut zur Diskussion stellen)

1. **Umlaut-Layer**: Standard-Layout `us` mit Variante **`altgr-intl`**. Also `input { kb_layout = us; kb_variant = altgr-intl; kb_options = ctrl:swap_lalt_lctl }`. **Kein** Custom-XKB-File. Das alte `.Xmodmap`-Mapping wird bewusst durch us-international ersetzt (Umlaute via AltGr).
2. **Clipboard & Zusatz-Tools**:
   - Screenshots nutzen **`wl-copy`** statt `copyq`: `grim -g "$(slurp)" - | wl-copy -t image/png`. `copyq` wird komplett aus Keybinds/Autostart entfernt.
   - `enpass`, `nextcloud`, `playerctl`, `copyq` aus Autostart entfernen — User installiert bei Bedarf manuell nach. (`suspend-if-idle` darf `playerctl` weiter aufrufen; es wird nur nicht vom Installer bereitgestellt.)
   - `xidlehook` entfällt (→ `hypridle`).
3. **`fix-displays-after-resume`**: ersatzlos **streichen** — Skript `.local/bin/fix-displays-after-resume` und Unit `.local/share/systemd/system/fix-displays-after-resume.service` löschen. Resume/DPMS macht Hyprland selbst.
4. **Multi-Monitor via kanshi mit EDID-Matching (wichtig — Daisy-Chain/MST!)**: Outputs kommen nach Resume/Hotplug verzögert und nacheinander hoch, Namen können wechseln. Deshalb **EDID-Seriennummern-basierte Erkennung beibehalten**: kanshi-Profile per Monitor-**Serial/Description** matchen, NICHT per Output-Name. Alle bisherigen Layouts als kanshi-Profile nachbauen (Details §6).

---

## 1. Was der Installer jetzt bereitstellt (Paket-Kontext)

**Installiert (Wayland):** `hyprland`, `xdg-desktop-portal-hyprland`, `qt5-wayland`, `qt6-wayland`, `hyprlock`, `hypridle`, `wlr-randr`, `kanshi`, `grim`, `slurp`, `wl-clipboard`, `wf-recorder`, `rofi-wayland`, `dunst`, `brightnessctl`.

**Entfernt / NICHT mehr installiert:** `qtile`, `xorg`, `xorg-xinit`, `xsecurelock`, `xss-lock`, `picom`, `numlockx`, `xorg-xmodmap`, `arandr`, `maim`, `slop`, `xclip`, `simplescreenrecorder`. **Kein `xorg-xwayland`** — alle GUI-Apps müssen nativ unter Wayland laufen. `copyq`, `enpass`, `nextcloud`, `playerctl`, `xidlehook` werden ebenfalls nicht installiert (siehe §0.2).

---

## 2. Dateien, die gelöscht werden (X11-only)

| Datei | Inhalt heute | Aktion |
|-------|--------------|--------|
| `.xinitrc` | sourct `.xprofile`, `exec qtile start`, auskommentierte xrandr-Zeilen, `dbus-update-activation-environment` | **löschen** |
| `.xprofile` | `QT_AUTO_SCREEN_SCALE_FACTOR=0`, `QT_SCALE_FACTOR=1`, `XCURSOR_SIZE=16` | **löschen**, Env → Hyprland `env =` (§5) |
| `.Xresources` | `Xcursor.size: 16` | **löschen** → `env = XCURSOR_SIZE,16` |
| `.Xmodmap` | Umlaut-Layer via Mode_switch, Num_Lock, Alt/Meta | **löschen** → ersetzt durch `altgr-intl` (§0.1) |
| `.config/picom/picom.conf` | X-Compositor | **löschen** |
| `.config/qtile/` (ganzer Baum) | config.py, settings/*.py, autostart.sh, themes | **löschen** → `.config/hypr/` |
| `.config/autostart/screenlayout.desktop` | XDG-Autostart → `autoselect.sh` | **löschen** → Hyprland `exec-once` |
| `.screenlayout/` (alle `.sh`) | xrandr-Layouts + EDID-Autoselect | **ersetzen** durch kanshi (§6) |
| `.local/bin/fix-displays-after-resume` | X11-Resume-Hack | **löschen** (§0.3) |
| `.local/share/systemd/system/fix-displays-after-resume.service` | systemd-Unit dazu | **löschen** (§0.3) |

---

## 3. qtile-Config → minimale Hyprland-Config (`.config/hypr/hyprland.conf`)

Keybinds aus `.config/qtile/settings/keys.py` (`mod = mod4` = Super):

| qtile | Funktion | Hyprland |
|-------|----------|----------|
| `mod+shift+Return` → wezterm | Terminal | `bind = SUPER SHIFT, Return, exec, wezterm` |
| `mod+space` → `rofi -show drun` | Launcher | `bind = SUPER, Space, exec, rofi -show drun` |
| `mod+shift+w` → `rofi -show window` | Fenster | `bind = SUPER SHIFT, W, exec, rofi -show window` |
| `mod+shift+e` → `rofi -show emoji` | Emoji | `bind = SUPER SHIFT, E, exec, rofi -show emoji` |
| `mod+shift+q` → `powermenu` | Powermenu | `bind = SUPER SHIFT, Q, exec, powermenu` |
| `mod+shift+b` → firefox | Browser | `bind = SUPER SHIFT, B, exec, firefox` |
| `mod+shift+l` → `lock` | Lock | `bind = SUPER SHIFT, L, exec, loginctl lock-session` |
| `mod+shift+x` → kill | schließen | `bind = SUPER SHIFT, X, killactive` |
| `mod+f` / `mod+shift+f` | fullscreen/float | `bind = SUPER, F, fullscreen, 0` / `togglefloating` |
| `mod+Tab` | Layout | `bind = SUPER, Tab, cyclenext` (dwindle/master) |
| `mod+r` / `mod+control+r` | reload | `bind = SUPER CTRL, R, exec, hyprctl reload` |
| `mod+control+q` | exit | `bind = SUPER CTRL, Q, exit` |
| `mod+q/w/e` → to_screen(2/0/1) | Monitor-Fokus | `bind = SUPER, Q/W/E, focusmonitor, <name>` |
| `XF86Audio*` → `changevolume` | Lautstärke | `bindl = , XF86AudioMute, exec, changevolume mute` usw. |
| `XF86MonBrightness*` → `changebacklight` | Helligkeit | `bindl = , XF86MonBrightnessUp, exec, changebacklight up` usw. |
| `mod+shift+d` → `display_desktop` | Display | durch kanshi/Monitor-Keybind ersetzen |

**Screenshots (neu, mit grim/slurp/wl-copy statt slop/maim/copyq):**
- `mod+ctrl+shift+s` Bereich → Clipboard: `grim -g "$(slurp)" - | wl-copy -t image/png`
- `mod+shift+s` → ebenfalls `grim -g "$(slurp)" - | wl-copy -t image/png` (Region-Cache entfällt; optional `slurp`-Ausgabe in Datei cachen)
- `mod+mod1+shift+s` als Datei: `grim -g "$(slurp)" ~/Documents/screenshot_$(date +%Y%m%d_%H%M%S).png`

**Autostart → `exec-once`:** aus `.config/qtile/autostart.sh` bleiben nur: `dunst`. Entfallen: `xrdb`, `picom`, `numlockx` (→ `input { numlock_by_default = true }`), `xset -dpms`/`xset s off`, `xidlehook`, `display_env`, `copyq`, `enpass`, `nextcloud`. Neu: `exec-once = hypridle`, `exec-once = kanshi`, `exec-once = dunst`.

---

## 4. Input (verbindlich, §0.1)
```
input {
    kb_layout = us
    kb_variant = altgr-intl
    kb_options = ctrl:swap_lalt_lctl
    numlock_by_default = true
    touchpad {
        tap-to-click = true
    }
}
```

## 5. Environment → Hyprland `env =`
```
env = XCURSOR_SIZE,16
env = QT_AUTO_SCREEN_SCALE_FACTOR,0
env = QT_SCALE_FACTOR,1
env = MOZ_ENABLE_WAYLAND,1
env = QT_QPA_PLATFORM,wayland
env = SDL_VIDEODRIVER,wayland
env = _JAVA_AWT_WM_NONREPARENTING,1
```

## 6. Monitor-Layouts → kanshi mit EDID-Match (§0.4)

Heute per `.screenlayout/autoselect.sh`: EDID-Serial-Erkennung (`xrandr --props` + Python-Parsing), drei Fälle. Bekannte Monitore:
- Primary 4K (Dell U3225QE): Serial **`D02G684`** → 3840x2160, Pos `2160x840`, normal
- Portrait 4K (Dell U2723QE): Serial **`C55F2H3`** → 3840x2160, Pos `0x0`, **rotate left**
- Laptop `eDP-1`: 1920x1200 / 1920x1080 / nativ 2880x1920

Neue `.config/kanshi/config` mit einem `profile {}` je Fall, **Match per `description`/Serial** (robust gegen MST-Reihenfolge und Output-Namenswechsel):
- **Desktop** (beide Externe, kein eDP): Primary `D02G684` normal @ `2160,840`; Portrait `C55F2H3` transform 270 @ `0,0`.
- **Laptop + beide Externe**: zusätzlich `eDP-1` 1920x1200 unten bündig (alte Pos `6000x1920`).
- **Laptop allein**: nur `eDP-1` 1920x1200 @ `0,0`.
- `rotate left` → kanshi `transform 270` (ggf. `90` testen). Positionen aus den alten xrandr-Werten übernehmen.
- `xrandr --dpi 96` entfällt → Skalierung via Hyprland/kanshi `scale`.
- `exec-once = kanshi` in Hyprland. `.config/kanshi/config` in `install.config.yml` verlinken.

Die festen Varianten (`desktop.sh`, `office-1-2.sh`, `office-2-1.sh`, `office.sh`, `single.sh`) als weitere kanshi-Profile bzw. optionale Hyprland-Keybinds abbilden. `test-edp-modes` (Debug) optional nach `wlr-randr` portieren oder löschen.

> Den exakten kanshi-Match-String (`description "..."`) pro Monitor am lebenden System auslesen: `hyprctl monitors` bzw. `wlr-randr`. Die Serials oben dienen als Zuordnungshilfe. Portrait-Transform (270 vs. 90) einmal visuell verifizieren.

---

## 7. `.local/bin/`-Skripte — Status

| Skript | Status | Aktion |
|--------|--------|--------|
| `lock` | wrappt **xsecurelock** | **neu**: `exec hyprlock` |
| `powermenu` | rofi; „Log Out" → `qtile … shutdown`; „Lock" → `lock` | qtile-Zeile → `hyprctl dispatch exit`; Rest bleibt |
| `display_env` | ruft `autoselect.sh` (xrandr) | durch kanshi ersetzen / löschen |
| `fix-displays-after-resume` + `.service` | X11-Resume-Hack | **löschen** (§0.3) |
| `test-edp-modes` | xrandr-Mode-Test | optional → `wlr-randr` oder löschen |
| `changevolume` | **wpctl + dunstify** | bleibt ✅ |
| `changebacklight` | **brightnessctl + dunstify** | bleibt ✅ |
| `rofi-audio-sink` | wpctl + rofi | bleibt ✅ |
| `wifimenu` | nmcli + rofi + notify-send | bleibt ✅ |
| `suspend-if-idle` | playerctl + systemctl | bleibt ✅ (playerctl manuell) |
| `pinentry-custom` | GPG | bleibt ✅ |

---

## 8. Session-Start: tty1 → Hyprland statt startx

Drei Stellen starten X auf tty1:
- `.zshrc` (~Z.17-20): `if [ "$(tty)" = "/dev/tty1" ]; then startx 2> ~/.startx-stderr.log; logout; fi`
- `.zprofile` und `.bash_profile`: `if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && command -v startx …; then exec startx; fi`

Alle drei auf Hyprland umstellen, z.B.:
```sh
if [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
```
`~/.startx-stderr.log`-Logik entfällt.

---

## 9. `install.config.yml` (dotbot)

Im **Linux-Block** (`if: [ \`uname\` = Linux ]`) **entfernen**: `~/.xinitrc`, `~/.Xmodmap`, `~/.xprofile`, `~/.Xresources`, `~/.config/qtile`, `~/.config/autostart/screenlayout.desktop`, `~/.config/picom`, `~/.screenlayout`.

**Hinzufügen:**
```yaml
    ~/.config/hypr:
      path: .config/hypr
    ~/.config/kanshi:
      path: .config/kanshi
```
Bleiben: `~/.config/rofi`, `~/.config/dunst`, `~/.config/btop`, `~/.config/gtk-3.0`, `~/.config/mpv`, `~/.config/ncdu`, `~/.config/Thunar/uca.xml`, `~/.config/wireplumber/…`, `~/.local/bin`, Firefox-`.desktop`-Dateien.

> Hinweis: `fix-displays-after-resume.service` ist nicht einzeln in `install.config.yml` verlinkt (läuft über `~/.local/…`-Baum); Datei einfach im Repo löschen.

---

## 10. Verifikation (statisch)
1. `install.config.yml` YAML-parsen.
2. Dotbot-Dry-Run falls möglich.
3. Grep muss leer sein (außer bewusst Behaltenem):
   `grep -rIn -E 'xrandr|xmodmap|xclip|xsel|\bmaim\b|\bslop\b|xsecurelock|xss-lock|\bqtile\b|\bpicom\b|numlockx|\bscrot\b|arandr|startx|xinit|copyq' ~/.dotfiles --exclude-dir=.git --exclude-dir=.oh-my-zsh --exclude-dir=.powerlevel10k --exclude-dir=dotbot`
   Ausnahme: `suspend-if-idle` darf `playerctl` enthalten.
4. `.config/hypr/hyprland.conf` und `.config/kanshi/config` existieren; keine verwaisten Links in `install.config.yml`.
5. **Kein Commit/Push** — Working Tree dem User überlassen.
