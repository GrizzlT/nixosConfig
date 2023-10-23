{ config, pkgs, lib, grizz-zfs-diff, ... }:
let
  userName = "grizz";
  hostName = "clevo";
  hostId = "13eb44cc";
in
{
  imports = [
    ./disks.nix
    ./performance.nix
    ./persist.nix
    ./pipewire.nix
    ./printing.nix
    ./greetd
    ./style.nix
    ./vpn.nix
    ./firewall.nix
    ./tailscale.nix
    ./virtualization.nix
    ./storage.nix

    ./ecsc-dry-run.nix

    (import ./user.nix userName)
    (import ./network.nix hostName hostId)

    ../../modules/grizz-keyboard.nix
    ../../modules/nix-settings.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Very basic packages + packages requiring system access
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    grizz-zfs-diff
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  security.sudo.extraConfig = "Defaults lecture = never";

  system.stateVersion = "23.05";
}
