local wezterm = require('wezterm')
local colors = require('grizz.colors')

local M = {}

M.apply_to_config = function (config)
  config.color_scheme = "snazzy"
  colors.apply_tab_colors(config)

  config.font = wezterm.font 'Hack Nerd Font Mono'
  config.harfbuzz_features = {}

  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
end

return M
