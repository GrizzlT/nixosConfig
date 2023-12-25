{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fluffychat
    discord
    webcord
    element-desktop-wayland
    cinny-desktop

    spotifywm
  ];
}
