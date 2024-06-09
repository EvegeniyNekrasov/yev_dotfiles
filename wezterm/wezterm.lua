local wezterm = require("wezterm")
return {
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 13.0,
	font = wezterm.font("JetBrains Mono"),
	macos_window_background_blur = 30,
	window_background_opacity = 0.7,
	window_decorations = "RESIZE",
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},
}
