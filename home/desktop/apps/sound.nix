{ pkgs, ... }:
{
  home.packages = with pkgs; [
    easyeffects
    qpwgraph
  ];
}
