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
    daemon.settings = {
      "dns" = [
        "172.17.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
  };
}
