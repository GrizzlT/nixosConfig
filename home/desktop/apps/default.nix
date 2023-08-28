{ pkgs, lib, ... }@inputs:
{
  imports = [
    ./wezterm.nix
    ./browser.nix
    ./images.nix
    ./sound.nix
    ./zsh.nix
    ./chat.nix
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

    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    })

    pkgs.unstable.planify

    gtkwave
  ];
}
