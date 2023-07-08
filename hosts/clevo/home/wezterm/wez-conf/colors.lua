local wezterm = require('wezterm')
local M = {}

M.apply_tab_colors = function (config)
  config.window_frame = {
    font = wezterm.font { family = 'Hack Nerd Font Mono', weight = 'Bold' },
    active_titlebar_bg = "#686868",
    inactive_titlebar_bg = "#686868",
  }
  wezterm.on('format-tab-title', function (tab, tabs, panes, config, hover, max_width)
    if tab.is_active then
      return {
        {Foreground={Color="#eff0eb"}},
        {Text=" " .. tab.tab_index+1},
        {Foreground={Color="#eff0eb"}},
        {Text=": "},
        {Foreground={Color="#eff0eb"}},
        {Text=tab.active_pane.title .. " "},
        {Background={Color="#282a36"}},
      }
    end
    return {
      {Foreground={Color="#f1f1f0"}},
      {Text=" " .. tab.tab_index+1},
      {Foreground={Color="#f1f1f0"}},
      {Text=": "},
      {Foreground={Color="#f1f1f0"}},
      {Text=tab.active_pane.title .. " "},
    }
  end)
end

return M
