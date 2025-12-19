{ pkgs, ... }:
{
  imports = [
    ./eza.nix
  ];

  home.packages = with pkgs; [
    neofetch

    gron
    jq
    fd

    unzip
    zip
    p7zip

    dust
    duf
    dysk
    dua

    tokei

    gping
    bandwhich
    procs

    has
    httpie
    doggo
    mosh
    cachix

    shellcheck
  ];

  programs = {
    htop.enable = true;
    btop.enable = true;
    bash.enable = true;
    bat.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
  };
}
