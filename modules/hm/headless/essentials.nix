{ pkgs, ... }:
{
  imports = [
    ./eza.nix
  ];

  home.packages = with pkgs; [
    neofetch

    radicle-node
    radicle-desktop

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

  home.sessionVariables = {
    RAD_HOME = "$HOME/DATA/.radicle";
  };

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
