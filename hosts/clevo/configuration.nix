{ config, pkgs, lib, home-manager, nixSettings, ... }:
let
  userName = "grizz";
  hostName = "clevo";
  hostId = "13eb44cc";
in
{
  imports = [
    ./hardware.nix
    ./performance.nix
    ./persist.nix
    ./packages.nix
    ./services.nix
    ./style.nix

    ./mounts.nix
    ../../modules/grizz-keyboard.nix
    ../../modules/nix-settings.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.hostId = hostId;
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    127.0.0.1 facebook.com m.facebook.com
  '';

  security.sudo.extraConfig = "Defaults lecture = never";

  time.timeZone = "Europe/Brussels";

  users.mutableUsers = false;
  users.users.${userName} = {
    passwordFile = "/persist/users/${userName}/passwordFile";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    packages = [ home-manager.packages.${pkgs.system}.default ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "23.05";
}
