{ pkgs, ... }:
{
  programs = {
    home-manager.enable = true;
    htop.enable = true;
    bottom.enable = true;
    bash.enable = true;
  };
}
