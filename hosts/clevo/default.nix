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
    ./virtualisation.nix

    # ./ecsc-dry-run.nix
    ./betweenlands.nix
    ./morti-vpn.nix
    ./cacert.nix

    ./user.nix
    ./network.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
    "steam-original"
    "steam-run"
    "corefonts"
    "helvetica-neue-lt-std"
    "vista-fonts"
  ];

  security.sudo.extraConfig = "Defaults lecture = never";

  system.stateVersion = "23.11";
}
