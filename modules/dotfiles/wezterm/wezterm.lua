local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'

config.font = wezterm.font("Monaco", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 14.0

config.front_end = "WebGpu"

config.enable_tab_bar = false


return config
