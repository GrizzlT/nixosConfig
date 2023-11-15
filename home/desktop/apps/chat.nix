{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fluffychat
    discord
    webcord
    element-desktop
    cinny-desktop

    spotifywm
  ];
}
