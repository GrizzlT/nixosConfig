{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher-qt5
    pkgs.unstable.lunar-client
  ];
}
