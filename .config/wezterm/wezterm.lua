local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.debug_key_events = true
config.term = "wezterm"

wezterm.on("update-status", function(window, pane)
	local mods, leds = window:keyboard_modifiers()
	window:set_right_status("mods=" .. mods .. " leds=" .. leds)
end)

config.font = wezterm.font("SauceCodePro Nerd Font Mono")
config.font_size = 13
config.color_scheme = "Vs Code Dark+ (Gogh)"
config.colors = {
	tab_bar = {
		background = "#000000",
	},
}

config.inactive_pane_hsb = {
	saturation = 0,
	brightness = 0.8,
}

-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 100

home = os.getenv("HOME")

local project_config = {
	[home .. "/projects/robinson/amello-frontend"] = { title = "Amello", color = "#3567F6" },
	[home .. "/projects/robinson/mapping-provider-admin"] = {
		title = "MappingProvider Admin",
		color = "#85ccd3",
	},
	[home .. "/projects/robinson/canto-frontify-sync"] = {
		title = "Canto-Frontify Sync",
		color = "#85ccd3",
	},
}

local function find_project_config(cwd)
	local best_match = nil
	local longest_prefix = 0

	for path, config in pairs(project_config) do
		if cwd:find(path, 1, true) and #path > longest_prefix then
			best_match = config
			longest_prefix = #path
		end
	end

	return best_match
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local cwd_uri = pane.current_working_dir and pane.current_working_dir or nil
	local cwd = cwd_uri and cwd_uri.file_path or ""
	local project = find_project_config(cwd)

	local title = nil
	local bg = nil
	local fg = "#000000"

	if project then
		title = project.title
		bg = project.color
	else
		title = tab.active_pane.title
		bg = "#CDCDCD"
	end

	if tab.is_active then
		title = " " .. title
		bg = "#ff2d00"
		fg = "#FFFFFF"
	end

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = "  " .. title .. "  " },
	}
end)

config.keys = {
	{
		key = "Enter",
		mods = "CTRL | SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "h",
		mods = "CTRL | SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Left",
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	},
	{
		key = "l",
		mods = "CTRL | SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	},
	{
		key = "j",
		mods = "CTRL | SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "CTRL | SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Up",
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	},
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action.SpawnTab({
			DomainName = "unix",
		}),
	},
}

return config
