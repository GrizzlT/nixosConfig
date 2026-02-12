{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    element-desktop

    fluffychat
  ];

  programs.vesktop.enable = true;
}
