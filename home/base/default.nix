{ pkgs, ... }@inputs:
{
  _module.args = {
    myPackages = inputs.self.packages.${pkgs.system};
  };

  imports = [
    ./style.nix
    ./neovim.nix
    ./git.nix
    ./xplr.nix
    ./broot.nix
    ./eza.nix

    ./productivity.nix
    ./ttrpg.nix

    ./passage.nix
    ./gpg.nix
    ./network-tools.nix

    ./zsh
    ./fish.nix
  ];

  home.packages = with pkgs; [
    neofetch
    tokei
    jq
    fd
    unzip
    zip
    p7zip
    d2
    du-dust

    appimage-run
  ];

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    btop.enable = true;
    bottom.enable = true;
    bash.enable = true;
    bat.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
  };
}
