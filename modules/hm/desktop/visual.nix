{ pkgs, ... }:
{
  home.packages = with pkgs; [
    freecad
    openscad-unstable
    blender
    darktable
    digikam
    inkscape
    gimp
    imv
    swayimg
    vlc
  ];

  programs.mpv = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture wlrobs ];
  };
}
