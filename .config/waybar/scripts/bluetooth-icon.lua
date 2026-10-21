#!/usr/bin/env lua
-- Geraeteabhaengiges Bluetooth-Icon fuer Waybar (return-type: json).
-- Fragt verbundene Geraete via `bluetoothctl devices Connected` ab und mappt
-- den Geraete-Alias auf ein Icon. Ausgabe: eine Zeile JSON (text, tooltip, class).
-- Laeuft unveraendert mit `lua` und `luajit`.

-- ------------------------------------------------------------------
-- ICON-MAPPING: {Alias-Teilstring (lowercase), Glyph}.
-- Reihenfolge zaehlt: das erste passende Muster gewinnt.
-- ------------------------------------------------------------------
local ICONS = {
  { "bose", "󰋋" },          -- Bose QuietComfort 35 -> Kopfhoerer
  { "quietcomfort", "󰋋" },
  { "headphone", "󰋋" },
  { "headset", "󰋋" },
  { "wh-", "󰋋" },           -- Sony WH-Serie
  { "airpods", "󰟎" },
  { "mouse", "󰍽" },
  { "keyboard", "󰌌" },
  { "speaker", "󰓃" },
  { "controller", "󰊴" },
}

local ICON_DEFAULT = "󰂱"   -- verbunden, kein Muster getroffen
local ICON_NONE = "󰂲"      -- kein Geraet verbunden

-- Minimaler JSON-String-Escaper (nur was hier vorkommen kann).
local function esc(s)
  s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
  return s
end

local function connected_aliases()
  local aliases = {}
  local h = io.popen("bluetoothctl devices Connected 2>/dev/null")
  if not h then return aliases end
  for line in h:lines() do
    -- Zeilenformat: "Device <MAC> <Alias...>"
    local alias = line:match("^Device%s+%S+%s+(.+)$")
    if alias and alias ~= "" then
      aliases[#aliases + 1] = alias
    end
  end
  h:close()
  return aliases
end

local function icon_for(alias)
  local lower = alias:lower()
  for _, pair in ipairs(ICONS) do
    if lower:find(pair[1], 1, true) then
      return pair[2]
    end
  end
  return ICON_DEFAULT
end

local aliases = connected_aliases()

if #aliases == 0 then
  io.write(string.format(
    '{"text":"%s","tooltip":"Kein Geraet verbunden","class":"disconnected"}\n',
    ICON_NONE))
  return
end

local icons, tips = {}, {}
for _, a in ipairs(aliases) do
  icons[#icons + 1] = icon_for(a)
  tips[#tips + 1] = esc(a)
end

io.write(string.format(
  '{"text":"%s","tooltip":"%s","class":"connected"}\n',
  table.concat(icons, " "), table.concat(tips, "\\n")))
