{ pkgs, ... }:
{
  imports = [
    ../../common/nix-settings.nix
  ];

  programs.home-manager.enable = true;
}
