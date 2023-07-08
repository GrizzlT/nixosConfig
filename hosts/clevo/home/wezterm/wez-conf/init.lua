local wezterm = require('wezterm')

local M = {}

M.apply_to_config = function (config)
  config.color_scheme = "snazzy"

  config.font = wezterm.font 'Hack Nerd Font Mono'
  config.harfbuzz_features = {}
end

return M
