local wezterm = require('wezterm')
local M = {}

M.apply_tab_colors = function (config)
  local C_ACTIVE_BG = "#282a36";
  local C_ACTIVE_FG = "#eff0eb";
  local C_BG = "#686868";
  local C_INACTIVE_FG = "#f1f1f0";

  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    if tab.is_active then
      return {
        {Background={Color=C_ACTIVE_BG}},
        {Foreground={Color=C_ACTIVE_FG}},
        {Text=" " .. tab.tab_index+1},
        {Foreground={Color=C_ACTIVE_FG}},
        {Text=": "},
        {Foreground={Color=C_ACTIVE_FG}},
        {Text=tab.active_pane.title .. " "},
      }
    end
    return {
      {Foreground={Color=C_INACTIVE_FG}},
      {Text=" " .. tab.tab_index+1},
      {Foreground={Color=C_INACTIVE_FG}},
      {Text=": "},
      {Foreground={Color=C_INACTIVE_FG}},
      {Text=tab.active_pane.title .. " "},
    }
  end)

  config.window_frame = {
    font = wezterm.font { family = 'Hack Nerd Font Mono', weight = 'Bold' },
    active_titlebar_bg = C_BG,
    inactive_titlebar_bg = C_BG,
  }
end

return M
