{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        harfbuzz_features = {}
        disable_default_key_bindings = true
        key_map_preference = "Mapped"
      }
    '';
  };
}
