{ pkgs, lib, ... }@inputs:
{
  imports = [
    ./wezterm
    ./librewolf.nix
    ./zsh.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "discord"
    ];

  home.packages = with pkgs; [
    xdg-utils
    thunderbird
    gpgme

    firefox
    brave

    fluffychat
    discord
    spotifywm

    freecad
    darktable
    inkscape
    gimp
    imv

    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    })
    easyeffects
    qpwgraph
    vlc

    prismlauncher

    pkgs.unstable.planify

    gtkwave
  ];

  programs.foot.enable = true;
}
