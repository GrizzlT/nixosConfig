{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fluffychat
    discord
    spotifywm
  ];
}
