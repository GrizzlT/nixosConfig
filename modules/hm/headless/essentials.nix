{ pkgs, ... }:
{
  imports = [
    ./eza.nix
  ];

  home.packages = with pkgs; [
    neofetch
    jq
    fd
    unzip
    zip
    p7zip
    du-dust
    duf
    tokei
    gping
    bandwhich
    procs
    has
    httpie
    doggo
    mosh
    cachix
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
