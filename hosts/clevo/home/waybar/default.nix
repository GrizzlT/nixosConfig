{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      layer = "top";
      position = "top";
      modules-left = [ "cpu" "temperature" "backlight" ];
      modules-center = [ "clock" ];
      modules-right = [ "mpd" "pulseaudio" "network" "battery" ];
    };
  };
}
