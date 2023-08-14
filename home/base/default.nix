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

    ./zsh
  ];

  home.packages = with pkgs; [
    tokei
    ifuse
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
  };
}
