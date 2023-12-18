{ pkgs, myPackages, ... }:
{
  home.packages = with pkgs; [
    myPackages.porsmo
    qrcp
  ];
}
