local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Dracula'
config.keys = {
  { key = "=", mods = "SUPER", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "SUPER", action = wezterm.action.DecreaseFontSize },
  { key = 'w', mods = 'CMD',   action = wezterm.action.CloseCurrentTab { confirm = false }, },
}

-- config.font = wezterm.font "SourceCodePro Nerd Font"
config.font_size = 18
config.audible_bell = "Disabled"
config.window_close_confirmation = "NeverPrompt"

return config
