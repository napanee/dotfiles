-- Hyprland configuration (Lua-Format)
-- Migriert von qtile (X11) auf Hyprland (Wayland). Siehe MIGRATION.md.
-- Von hyprlang (.conf) auf das neue Lua-Format portiert (Hyprland 0.56.2;
-- .conf ist seit 0.55 deprecated und wird in 0.57 entfernt).
-- Doku: https://wiki.hypr.land/Configuring/

----------------
--- MONITORS ---
----------------

-- Monitor-Layouts werden dynamisch von kanshi (EDID-/Serial-Match) gesetzt,
-- siehe ~/.config/kanshi/config. Hier nur ein sinnvoller Fallback, damit auch
-- ohne kanshi-Profil ein Bild erscheint.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Workspace-zu-Monitor-Zuordnung (uebernommen aus qtile screen_mappings[3]).
-- qtile Screen 0 = DP-2, Screen 1 = DP-1, Screen 2 = eDP-1.
--   DP-2  (SUPER+Q): Workspaces 1-3
--   eDP-1 (SUPER+E): Workspaces 4-5
--   DP-1  (SUPER+W): Workspaces 6-9
-- Hinweis: Monitor-Namen ggf. mit `hyprctl monitors` pruefen. Fehlt ein Monitor
-- (z.B. nur 1-2 angeschlossen), landen dessen Workspaces automatisch auf einem
-- vorhandenen Monitor.
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })
hl.workspace_rule({ workspace = "4", layout_opts = { orientation = "top" }, monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "5", layout_opts = { orientation = "top" }, monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
hl.workspace_rule({ workspace = "8", monitor = "DP-1" })
hl.workspace_rule({ workspace = "9", monitor = "DP-1" })

-------------------
--- ENVIRONMENT ---
-------------------

hl.env("XCURSOR_SIZE", "16")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_options = "ctrl:swap_lalt_lctl",
        numlock_by_default = true,
        follow_mouse = 2,
        touchpad = {
            tap_to_click = true,
        },
    },
})

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("kanshi")
    hl.exec_cmd("dunst")
    hl.exec_cmd("waybar")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)

---------------
--- LAYOUTS ---
---------------

-- Layout- und Darstellungs-Settings. Keys gegen die 0.56.2-Beispielconfig
-- verifiziert: https://github.com/hyprwm/Hyprland/blob/v0.56.2/example/hyprland.lua
hl.config({
    general = {
        layout      = "master",
        gaps_in     = 2,
        gaps_out    = 4,
        border_size = 1,
        col = {
            active_border   = "rgba(d65d0eff)",
            inactive_border = "rgba(595959aa)",
        },
    },

    decoration = {
        rounding = 0,
        inactive_opacity = 0.9,
        shadow = {
            enabled = false
        }
    },

    master = {
        orientation = "left",
        mfact       = 0.5,
    },

    misc = {
        -- Festes eingebautes Wallpaper (/usr/share/hypr/wall2.png) statt
        -- zufaelliger Auswahl (-1). 0 = keins, 1 = wall1, 2 = wall2.
        force_default_wallpaper = 2,
    },
})

--------------------
--- WINDOW RULES ---
--------------------

hl.window_rule({
    name = "enpass-float",
    match = { class = "^(enpass)$" },
    float = true,
    center = true,
    fullscreen_state = "0 0",
    suppress_event = "maximize",
})

------------------
--- ANIMATIONS ---
------------------

hl.animation({ leaf = "workspaces", enabled = true, speed = 5, spring = "default", style = "fade" })

-------------------
--- KEYBINDINGS ---
-------------------

local mod = "SUPER"

-- Apps
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd("wezterm"))
hl.bind(mod .. " + Space",          hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + SHIFT + W",      hl.dsp.exec_cmd("rofi -show window"))
hl.bind(mod .. " + SHIFT + E",      hl.dsp.exec_cmd("rofi -show emoji"))
hl.bind(mod .. " + SHIFT + Q",      hl.dsp.exec_cmd("powermenu"))
hl.bind(mod .. " + SHIFT + B",      hl.dsp.exec_cmd("firefox"))

-- Session / Lock
hl.bind(mod .. " + SHIFT + L",      hl.dsp.exec_cmd("loginctl lock-session"))

-- Window management
hl.bind(mod .. " + SHIFT + X",      hl.dsp.window.close())
hl.bind(mod .. " + F",              hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + SHIFT + F",      hl.dsp.window.float({ action = "toggle" }))

-- Layout pro Workspace setzen (qtile: feste Layout-Shortcuts, kein Cycle).
--   Comma  -> master, orientation left (monad)
--   Period -> master, orientation top  (monadWide)
--   Slash  -> monocle                  (max)
local function set_ws_layout(layout, orientation)
    return function()
        local ws = hl.get_active_workspace()
        if not ws then return end
        local spec = { workspace = "name:" .. tostring(ws.name), layout = layout }
        if orientation then
            spec.layout_opts = { orientation = orientation }
        end
        hl.workspace_rule(spec)
    end
end

hl.bind(mod .. " + Comma",          set_ws_layout("master", "left"))
hl.bind(mod .. " + Period",         set_ws_layout("master", "top"))
hl.bind(mod .. " + Slash",          set_ws_layout("monocle"))

-- Layout management
hl.bind(mod .. " + Return",         hl.dsp.layout("swapwithmaster"))
hl.bind(mod .. " + SHIFT + Equal",  hl.dsp.layout("mfact +0.05"))
hl.bind(mod .. " + SHIFT + Minus",  hl.dsp.layout("mfact -0.05"))
hl.bind(mod .. " + Down",           hl.dsp.layout("cyclenext"))
hl.bind(mod .. " + Up",             hl.dsp.layout("cycleprev"))
hl.bind(mod .. " + SHIFT + Down",   hl.dsp.layout("swapnext"))
hl.bind(mod .. " + SHIFT + Up",     hl.dsp.layout("swapprev"))
hl.bind(mod .. " + SHIFT + J",      hl.dsp.layout("addmaster"))
hl.bind(mod .. " + SHIFT + K",      hl.dsp.layout("removemaster"))

-- Mouse: Move / Resize windows (qtile: SUPER + Drag)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Reload / Exit
hl.bind(mod .. " + CTRL + R",       hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + R",      hl.dsp.exec_cmd("sh -c 'killall waybar; sleep 0.3; waybar'"))
hl.bind(mod .. " + CTRL + Q",       hl.dsp.exit())

-- Workspaces (ersetzt qtile groups 1-9)
-- SUPER + <n>        : Workspace auswaehlen
-- SUPER SHIFT + <n>  : aktives Fenster in Workspace verschieben
for i = 1, 9 do
    hl.bind(mod .. " + " .. i,          hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i,  hl.dsp.window.move({ workspace = i }))
end

-- Monitor-Fokus (ersetzt qtile to_screen(2/0/1) fuer q/w/e)
-- TODO: Monitor-Namen am lebenden System pruefen (`hyprctl monitors`); unter
-- MST/Daisy-Chain koennen sich die Output-Namen aendern. Ggf. auf Richtungen
-- (l/r/u/d) oder konkrete Namen anpassen.
hl.bind(mod .. " + Q", hl.dsp.focus({ monitor = "DP-2" }))
hl.bind(mod .. " + W", hl.dsp.focus({ monitor = "DP-1" }))
hl.bind(mod .. " + E", hl.dsp.focus({ monitor = "eDP-1" }))

-- Screenshots (grim/slurp/wl-copy statt slop/maim/copyq)
-- sh -c fuehrt die Pipe / $() zur Laufzeit aus; einfache Lua-Strings lassen
-- die inneren Anfuehrungszeichen um $(slurp) unveraendert.
hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy -t image/png'))
hl.bind(mod .. " + SHIFT + S",        hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy -t image/png'))
hl.bind(mod .. " + ALT + SHIFT + S",  hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Documents/screenshot_$(date +%Y%m%d_%H%M%S).png'))

-- Volume (locked = auch im gesperrten/inaktiven Zustand, entspricht bindl)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("changevolume mute"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("changevolume down"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("changevolume up"),   { locked = true })

-- Backlight
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("changebacklight down"), { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("changebacklight up"),   { locked = true })
