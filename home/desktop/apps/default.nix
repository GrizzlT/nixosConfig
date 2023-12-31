{ pkgs, lib, ... }@inputs:
{
  imports = [
    ./wezterm.nix
    ./browser.nix
    ./images.nix
    ./games.nix
    ./sound.nix
    ./zsh.nix
    ./chat.nix
    ./zathura.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "discord"
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
  ];

  home.packages = with pkgs; [
    xdg-utils
    thunderbird
    gpgme

    filezilla
    unstable.gitkraken

    (unstable.wrapOBS {
      plugins = with unstable.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    })

    pkgs.unstable.planify

    gtkwave
  ];
}
