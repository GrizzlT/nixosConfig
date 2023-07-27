{ pkgs, ... }@inputs:
{
  _module.args = {
    myPackages = inputs.self.packages.${pkgs.system};
  };

  imports = [
    ./style.nix

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
