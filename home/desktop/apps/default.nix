{ pkgs, ... }@inputs:
{
  imports = [
    ./wezterm
    ./librewolf.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    thunderbird
    gpgme

    brave

    fluffychat
    discord
    spotifywm

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
