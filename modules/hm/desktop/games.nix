{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
    unstable.lunar-client
  ];
}
