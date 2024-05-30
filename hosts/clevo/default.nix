{ lib, ... }:
let
  commonModules = builtins.attrValues (builtins.removeAttrs [
    "virtualisation"
  ] (import ../../modules/nixos));
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
    ./cacert.nix

    ./user.nix
    ./network.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  security.sudo.extraConfig = "Defaults lecture = never";

  system.stateVersion = "23.11";
}
