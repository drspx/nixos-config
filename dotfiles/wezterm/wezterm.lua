local wezterm = require("wezterm")

local background = {
	{
		source = {
			File = wezterm.config_dir .. "/backdrops/voyage.jpg", -- Path to your image
		},
		-- Adjust opacity and scaling
		opacity = 0.9, -- 0.0 (transparent) to 1.0 (opaque)
		hsb = { brightness = 0.1 }, -- Darken the image for better contrast
		width = "100%",
		height = "100%",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		vertical_align = "Middle",
		horizontal_align = "Center",
	},
}

local config = wezterm.config_builder()

config.default_prog = { "fish" }
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 10.0
config.window_background_opacity = 0.85
config.enable_tab_bar = false
config.window_decorations = "NONE"
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.initial_cols = 120
config.initial_rows = 40
-- config.kde_window_background_blur = true
-- config.wayland_window_background_blur = true

return config
