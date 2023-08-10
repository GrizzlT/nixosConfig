{ pkgs, ... }@inputs:
{
  _module.args = {
    myPackages = inputs.self.packages.${pkgs.system};
  };

  imports = [
    ./style.nix
    ./neovim.nix
    # ../../modules/neovim

    ./zsh
  ];

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    bottom.enable = true;
    bash.enable = true;

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
