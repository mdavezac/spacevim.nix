-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.default_prog = { "nu", "-l" }
config.color_scheme = "Apprentice"
config.font = wezterm.font("VictorMono Nerd Font")
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
config.keys = {
	{
		key = "1",
		mods = "ALT",
		action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	{
		key = "2",
		mods = "ALT",
		action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }),
	},
}

-- and finally, return the configuration to wezterm
return config
