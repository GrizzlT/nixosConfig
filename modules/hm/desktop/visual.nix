{ pkgs, ... }:
{
  home.packages = with pkgs; [
    freecad
    openscad-unstable
    blender
    darktable
    digikam
    shotwell
    (inkscape-with-extensions.override {
      inkscapeExtensions = with inkscape-extensions; [ inkstitch ];
    })
    gimp
    imv
    swayimg
    vlc

    yt-dlp
    droidcam
    mumble
  ];

  programs.mpv = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-pipewire-audio-capture wlrobs droidcam-obs ];
  };

  programs.satty.enable = true;
  programs.hyprshot.enable = true;
}
