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
