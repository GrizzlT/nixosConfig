{ pkgs, ... }:
{
  imports = [
    ./style.nix
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
