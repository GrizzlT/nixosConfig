{ pkgs, ... }:
{
  programs.zathura.enable = true;

  home.packages = with pkgs; [
    thunderbird

    appimage-run
  ];
}
