{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fluffychat
    discord
    webcord

    spotifywm
  ];
}
