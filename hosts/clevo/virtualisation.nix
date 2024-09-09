{ ... }:
let
  common = import ../../modules/nixos;
in
{
  imports = [
    common.virtualisation
  ];

  virtualisation.docker = {
    storageDriver = "zfs";
  };
}
