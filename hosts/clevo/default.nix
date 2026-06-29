{ lib, ... }:
let
  commonModules = builtins.attrValues (builtins.removeAttrs (import ../../modules/nixos) [
    "virtualisation"
  ]);
in
{
  imports = commonModules ++ [
    ./age.nix
    ./disks.nix
    ./firewall.nix
    ./greetd
    ./performance.nix
    ./persist.nix
    ./storage.nix
    ./udev.nix
    ./syncthing.nix
    ./virtualisation.nix
    ./murmur.nix

    # ./ecsc-dry-run.nix
    ./vpn.nix
    ./cacert.nix

    ./user.nix
    ./network.nix
  ];

  services.fwupd.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
    "steam-original"
    "steam-run"
    "corefonts"
    "helvetica-neue-lt-std"
    "vista-fonts"
    "saleae-logic-2"
  ];

  security.sudo.extraConfig = "Defaults lecture = never";

  system.stateVersion = "26.05";
}
