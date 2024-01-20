{ lib, selfNixos, inputNixos, ... }:
let
  userName = "grizz";
  hostName = "clevo";
  hostId = "13eb44cc";
in
{
  imports = with selfNixos; [
    inputNixos.agenix.default
    inputNixos.impermanence.impermanence

    keyboardConfig
    nixConfig

    locale
    minimalPackages
    pipewire
    printing
    stylix
    tailscale
    xorg

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
