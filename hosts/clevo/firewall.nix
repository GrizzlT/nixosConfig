{ pkgs, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
}
