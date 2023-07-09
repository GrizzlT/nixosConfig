local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

M.apply_to_config = function (config)
  config.disable_default_key_bindings = true
  config.key_map_preference = "Mapped"

  -- Show which key table is active in the status area
  wezterm.on('update-right-status', function(window, pane)
    local name = window:active_key_table()
    if name then
      name = 'TABLE: ' .. name
    end
    window:set_right_status(name or '')
  end)

  config.leader = { key = 'e', mods = 'CTRL', timeout_milliseconds = 1000 }
  config.keys = {
    { key = 'e', mods = 'LEADER|CTRL', action = act.SendKey { key = 'e', mods = 'CTRL' }},
  }
end

return M
