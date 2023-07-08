local wezterm = require('wezterm')

local M = {}

M.apply_to_config = function (config)
  config.font = wezterm.font 'Hack'
  config.harfbuzz_features = {}
end

return M
