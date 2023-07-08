{ pkgs, ... }:
let
    configPath = ".config/wezterm/grizz";
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local myConfig = require('grizz')
      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end
      myConfig.apply_to_config(config)
      return config
    '';
  };

  home.file."${configPath}" = {
    source = ./wez-conf;
    recursive = true;
  };
}
