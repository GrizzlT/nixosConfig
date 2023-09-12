{ pkgs, ... }:
{
  home.packages = with pkgs; [
    freecad
    darktable
    inkscape
    gimp
    imv
    swayimg
    vlc
  ];

  programs.mpv = {
    enable = true;
  };
}
