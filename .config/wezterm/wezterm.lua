local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font 'SauceCodePro Nerd Font Mono'
config.font_size = 12
config.color_scheme = "Vs Code Dark+ (Gogh)"
config.colors = {
  tab_bar = {
    background = '#000000',
	},
}

-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on(
	'format-tab-title',
	function(tab, tabs, panes, config, hover, max_width)
		local title = tab_title(tab)
		if tab.is_active then
			return {
				{ Text = ' >' .. title .. '< ' },
			}
		end
		return ' |' .. title .. '| '
	end
)

config.keys = {
	{
		key = 'Enter',
		mods = 'SUPER | SHIFT',
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = 'h',
		mods = 'SUPER | SHIFT',
		action = wezterm.action.SplitPane {
			direction = 'Left',
			command = { domain = 'CurrentPaneDomain' },
			size = { Percent = 50 },
		},
	},
	{
		key = 'l',
		mods = 'SUPER | SHIFT',
		action = wezterm.action.SplitPane {
			direction = 'Right',
			command = { domain = 'CurrentPaneDomain' },
			size = { Percent = 50 },
		},
	},
	{
		key = 'j',
		mods = 'SUPER | SHIFT',
		action = wezterm.action.SplitPane {
			direction = 'Down',
			command = { domain = 'CurrentPaneDomain' },
			size = { Percent = 50 },
		},
	},
	{
		key = 'k',
		mods = 'SUPER | SHIFT',
		action = wezterm.action.SplitPane {
			direction = 'Up',
			command = { domain = 'CurrentPaneDomain' },
			size = { Percent = 50 },
		},
	}
}

return config
