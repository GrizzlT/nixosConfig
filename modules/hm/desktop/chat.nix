{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    element-desktop
  ];

  programs.vesktop.enable = true;
}
