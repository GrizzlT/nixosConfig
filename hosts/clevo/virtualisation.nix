{ pkgs, ... }:
let
  common = import ../../modules/nixos;
in
{
  imports = [
    common.virtualisation
  ];

  virtualisation.docker = {
    storageDriver = "zfs";
    daemon.settings = {
      firewall-backend = "nftables";
    };
  };
  systemd.services.docker.path = [ pkgs.nftables ];
}
