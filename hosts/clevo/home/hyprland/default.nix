{ pkgs, ... }:
let
    configPath = ".config/hypr/grizz";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    recommendedEnvironment = true;
    extraConfig = "source=~/${configPath}/hyprland.conf";
  };

  home.file."${configPath}" = {
    source = ./hypr-conf;
    recursive = true;
  };

  home.file."${configPath}/scripts/gamemode.sh" = {
    source = ./scripts/gamemode.sh;
    executable = true;
  };

  home.file.".config/swaybg/bg.jpg".source = ./color-bg.jpg;
}
