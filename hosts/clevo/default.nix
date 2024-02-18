{ lib, ... }:
let
  userName = "grizz";
  hostName = "clevo";
  hostId = "13eb44cc";

  modulePath = ../../modules/nixos;
in
{
  imports = [
    (modulePath + "/grizz-keyboard.nix")
    (modulePath + "/nix-settings.nix")
    (modulePath + "/../nix-cache.nix")

    (modulePath + "/locale.nix")
    (modulePath + "/minimalPackages.nix")
    (modulePath + "/pipewire.nix")
    (modulePath + "/printing.nix")
    (modulePath + "/stylix.nix")
    (modulePath + "/tailscale.nix")
    (modulePath + "/xorg.nix")
    (modulePath + "/eid.nix")

    ./age.nix
    ./disks.nix
    ./firewall.nix
    ./greetd
    ./performance.nix
    ./persist.nix
    ./storage.nix
    ./virtualisation.nix

    # ./ecsc-dry-run.nix

    (import ./user.nix userName)
    (import ./network.nix hostName hostId)
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  security.sudo.extraConfig = "Defaults lecture = never";

  system.stateVersion = "23.11";
}
