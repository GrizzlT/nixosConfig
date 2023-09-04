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

    ./passage.nix
    ./gpg.nix

    ./zsh
  ];

  home.packages = with pkgs; [
    neofetch
    tokei
    jq
    fd
    unzip
    p7zip
    d2

    appimage-run
  ];

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    bottom.enable = true;
    bash.enable = true;
    bat.enable = true;

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
