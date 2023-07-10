local wezterm = require('wezterm')
local colors = require('grizz.colors')
local keys = require('grizz.keys')

local M = {}

M.apply_to_config = function (config)
  config.color_scheme = "snazzy"
  colors.apply_tab_colors(config)
  keys.apply_to_config(config)

  config.font = wezterm.font 'Hack Nerd Font Mono'
  config.font_size = 13.0
  config.harfbuzz_features = {}
end

return M
