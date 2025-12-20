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

    yt-dlp
  ];

  programs.mpv = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture wlrobs ];
  };

  programs.satty.enable = true;
  programs.hyprshot.enable = true;
}
