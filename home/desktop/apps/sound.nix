{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qpwgraph
    qjackctl
    jackmix
    pw-volume
  ];
}
