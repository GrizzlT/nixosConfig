{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local act = wezterm.action

      return {
        harfbuzz_features = {},

        tab_bar_at_bottom = true,
        colors = {
          cursor_fg = 'rgba(40, 42, 54)',
        },

        disable_default_key_bindings = true,
        key_map_preference = "Mapped",

        leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 },
        keys = {
          { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
          { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
          { key = '-', mods = 'SUPER|SHIFT', action = act.DecreaseFontSize },
          { key = '=', mods = 'SUPER|SHIFT', action = act.IncreaseFontSize },
          { key = '{', mods = 'SUPER|SHIFT', action = act.ResetFontSize },

          { key = 'n', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
          { key = 'n', mods = 'SUPER|SHIFT', action = act.SpawnTab 'DefaultDomain' },
          { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab { confirm = true } },

          { key = 'F1', action = act.ActivateTab(0) },
          { key = 'F2', action = act.ActivateTab(1) },
          { key = 'F3', action = act.ActivateTab(2) },
          { key = 'F4', action = act.ActivateTab(3) },
          { key = 'F5', action = act.ActivateTab(4) },
          { key = 'F6', action = act.ActivateTab(5) },
          { key = 'F7', action = act.ActivateTab(6) },
          { key = 'F8', action = act.ActivateTab(7) },
          { key = 'F9', action = act.ActivateTab(-1) },

          { key = 'f', mods = 'LEADER', action = act.Search({CaseInSensitiveString=""})},
          { key = 'c', mods = 'LEADER', action = act.ActivateCopyMode },

          { key = '-', mods = 'SUPER', action = act.SplitVertical({domain = "CurrentPaneDomain"})},
          { key = '%', mods = 'SUPER', action = act.SplitHorizontal({domain = "CurrentPaneDomain"})},
          { key = 'z', mods = 'SUPER', action = act.TogglePaneZoomState },

          { key = 's', mods = 'LEADER|CTRL', action = act.SendKey { key = 's', mods = 'CTRL' }},
          { key = 'o', mods = 'LEADER', action = act.ActivateLastTab },
          { key = 't', mods = 'LEADER', action = act.ActivateKeyTable { name = 'move_tab', one_shot = false }},
          { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
          { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
          { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false }},
          { key = 'a', mods = 'LEADER', action = act.ActivateKeyTable { name = 'activate_pane', timeout_milliseconds = 1000 }},
        },
        key_tables = {
          resize_pane = {
            { key = 'h', action = act.AdjustPaneSize { 'Left', 1 }},
            { key = 'j', action = act.AdjustPaneSize { 'Down', 1 }},
            { key = 'k', action = act.AdjustPaneSize { 'Up', 1 }},
            { key = 'l', action = act.AdjustPaneSize { 'Right', 1 }},
            { key = 'Escape', action = 'PopKeyTable' },
          },
          activate_pane = {
            { key = 'h', action = act.ActivatePaneDirection 'Left' },
            { key = 'j', action = act.ActivatePaneDirection 'Down' },
            { key = 'k', action = act.ActivatePaneDirection 'Up' },
            { key = 'l', action = act.ActivatePaneDirection 'Right' },
            { key = 'Escape', action = act.PopKeyTable },
          },
          move_tab = {
            { key = 'p', action = act.ActivateTabRelative(-1) },
            { key = 'n', action = act.ActivateTabRelative(1) },
            { key = 'p', mods = 'SHIFT', action = act.Multiple({ act.MoveTabRelative(-1), act.ActivateTabRelative(-1) }) },
            { key = 'n', mods = 'SHIFT', action = act.Multiple({ act.MoveTabRelative(1), act.ActivateTabRelative(1) }) },
            { key = 'Escape', action = act.PopKeyTable },
          },
        },

        wezterm.on('update-right-status', function(window, pane)
          local name = window:active_key_table()
          if name then
            name = 'TABLE: ' .. name
          end
          window:set_right_status(name or ''')
        end)
      }
    '';
  };
}
