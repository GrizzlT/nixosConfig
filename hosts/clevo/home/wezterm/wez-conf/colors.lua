local wezterm = require('wezterm')
local M = {}

M.apply_tab_colors = function (config)
  local selected_scheme = "tokyonight";
  local scheme = wezterm.get_builtin_color_schemes()[selected_scheme]

  local C_ACTIVE_BG = scheme.background;
  local C_ACTIVE_FG = scheme.foreground;
  local C_BG = scheme.brights[0];
  local C_INACTIVE_FG = scheme.ansi[7];

  scheme.tab_bar = {
    background = C_BG,
    new_tab = {
      bg_color = C_BG,
      fg_color = C_ACTIVE_BG,
    },
    new_tab_hover = {
      bg_color = C_BG,
      fg_color = C_ACTIVE_BG,
    },
    active_tab = {
      bg_color = C_ACTIVE_BG,
      fg_color = C_ACTIVE_FG,
    },
    inactive_tab = {
      bg_color = C_BG,
      fg_color = C_INACTIVE_FG,
    },
    inactive_tab_hover = {
      bg_color = C_BG,
      fg_color = C_INACTIVE_FG,
    }
  }

  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    if tab.is_active then
      return {
        {Foreground={Color=C_ACTIVE_FG}},
        {Text=" " .. tab.tab_index+1},
        {Foreground={Color=C_ACTIVE_FG}},
        {Text=": "},
        {Foreground={Color=C_ACTIVE_FG}},
        {Text=tab.active_pane.title .. " "},
        {Background={Color=C_ACTIVE_BG}},
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
    active_titlebar_bg = "#686868",
    inactive_titlebar_bg = "#686868",
  }
  config.color_schemes = {
    [selected_scheme] = scheme
  }
  config.color_scheme = selected_scheme
end

return M
