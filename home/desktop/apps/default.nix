{ pkgs, ... }@inputs:
{
  imports = [
    ./wezterm
    ./librewolf.nix
    ./thunderbird.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    fluffychat
    discord
    spotifywm

    darktable
    inkscape
    gimp
    imv

    lunar-client

    pkgs.unstable.planify

    gtkwave
  ];

  programs.foot.enable = true;
}
