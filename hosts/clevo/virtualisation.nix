{ ... }:
{
  imports = [
    ../../modules/nixos/virtualisation.nix
  ];

  virtualisation.docker.storageDriver = "zfs";
}
