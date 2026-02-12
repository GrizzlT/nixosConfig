{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    element-desktop

    fractal
  ];

  programs.vesktop.enable = true;
}
