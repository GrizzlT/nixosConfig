{ pkgs, ... }:
{
  home.packages = with pkgs; [
    freecad
    darktable
    inkscape
    gimp
    imv
    vlc
  ];
}
