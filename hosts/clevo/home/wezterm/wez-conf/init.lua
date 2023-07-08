local wezterm = require('wezterm')

local M = {}

M.apply_to_config = function (config)
  config.color_scheme = "snazzy"

  config.font = wezterm.font 'Hack Nerd Font Mono'
  config.harfbuzz_features = {}
  config.window_frame = {
    font = wezterm.font { family = 'Hack Nerd Font Mono', weight = 'Bold' },
    active_titlebar_bg = "#686868",
    inactive_titlebar_bg = "#686868",
  }
end

return M
