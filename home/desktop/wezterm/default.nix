{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        harfbuzz_features = {},

        tab_bar_at_bottom = true,
        colors = {
          cursor_fg = 'rgba(40, 42, 54)',
        },

        disable_default_key_bindings = true,
        key_map_preference = "Mapped",
      }
    '';
  };
}
