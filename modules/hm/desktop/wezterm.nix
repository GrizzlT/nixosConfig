{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = pkgs.unstable.wezterm;
    extraConfig = ''
      local act = wezterm.action

      local is_vim = function(pane)
        return pane:get_user_vars().IS_NVIM == 'true'
      end
      local direction_keys = {
        Left = 'h',
        Down = 'j',
        Up = 'k',
        Right = 'l',
        h = 'Left',
        j = 'Down',
        k = 'Up',
        l = 'Right',
      }

      local function split_nav(resize_or_move, key)
        return {
          key = key,
          mods = resize_or_move == 'resize' and 'ALT' or 'CTRL',
          action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
              win:perform_action({
                SendKey = { key = key, mods = resize_or_move == 'resize' and 'ALT' or 'CTRL' },

              }, pane)
            else
              if resize_or_move == 'resize' then
                win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 }}, pane)
              else
                win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
              end
            end
          end),
        }
      end

      return {
        harfbuzz_features = {},

        enable_wayland = false,
        audible_bell = "Disabled",

        tab_bar_at_bottom = true,
        colors = {
          cursor_fg = 'rgba(40, 42, 54)',
          compose_cursor = 'orange',
        },

        disable_default_key_bindings = true,
        key_map_preference = "Mapped",

        leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 },
        keys = {
          -- move
          split_nav('move', 'h'),
          split_nav('move', 'j'),
          split_nav('move', 'k'),
          split_nav('move', 'l'),
          -- resize
          split_nav('resize', 'h'),
          split_nav('resize', 'j'),
          split_nav('resize', 'k'),
          split_nav('resize', 'l'),

          { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
          { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
          { key = '-', mods = 'SUPER|ALT', action = act.DecreaseFontSize },
          { key = '=', mods = 'SUPER|ALT', action = act.IncreaseFontSize },
          { key = '{', mods = 'SUPER|ALT', action = act.ResetFontSize },

          { key = 'n', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
          { key = 'n', mods = 'SUPER|SHIFT', action = act.SpawnTab 'DefaultDomain' },
          { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab { confirm = true } },
          { key = 'x', mods = 'SUPER', action = act.CloseCurrentPane { confirm = true }},
          { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },

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

          { key = '-', mods = 'LEADER', action = act.SplitVertical({domain = "CurrentPaneDomain"})},
          { key = '%', mods = 'LEADER', action = act.SplitHorizontal({domain = "CurrentPaneDomain"})},
          { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

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
            { key = 'h', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 5 }},
            { key = 'j', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 5 }},
            { key = 'k', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 5 }},
            { key = 'l', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 5 }},
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
            { key = 'p', mods = 'SHIFT', action = act.MoveTabRelative(-1) },
            { key = 'n', mods = 'SHIFT', action = act.MoveTabRelative(1) },
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
