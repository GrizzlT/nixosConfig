{ selfNixos, ... }:
{
  imports = [
    selfNixos.virtualisation
  ];

  virtualisation.docker.storageDriver = "zfs";
}
