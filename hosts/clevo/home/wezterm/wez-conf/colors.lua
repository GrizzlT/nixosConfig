local wezterm = require('wezterm')
local M = {}

M.apply_tab_colors = function (config)
  local C_BG = "#686868";

  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false

  config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = 0,
    bottom = 0,
  }

  config.window_frame = {
    font = wezterm.font { family = 'Hack Nerd Font Mono', weight = 'Bold' },
    active_titlebar_bg = C_BG,
    inactive_titlebar_bg = C_BG,
  }
end

return M
