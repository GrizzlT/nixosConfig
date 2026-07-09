{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qpwgraph
    qjackctl
    jackmix
    pw-volume
  ];

  services.mpris-proxy.enable = true;
}
