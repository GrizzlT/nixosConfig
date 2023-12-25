{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.dice
  ];
}
