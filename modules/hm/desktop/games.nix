{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher-qt5
    unstable.lunar-client
  ];
}
