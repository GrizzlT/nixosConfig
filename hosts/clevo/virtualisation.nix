{ ... }:
{
  imports = [
    ../../modules/nixos/virtualisation.nix
  ];

  virtualisation.docker = {
    storageDriver = "zfs";
    daemon.settings = {
      "dns" = [
        "172.17.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
  };
}
