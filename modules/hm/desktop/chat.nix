{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fluffychat
    discord
    element-desktop-wayland
  ];
}
