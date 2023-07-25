{ config, pkgs, lib, home-manager, nixSettings, ... }:
let
  userName = "grizz";
  hostName = "clevo";
  hostId = "13eb44cc";
in
{
  imports = [
    ./hardware.nix
    ./optimize.nix
    ./persist.nix
    ./packages.nix
    ./services.nix
    ./style.nix
    ../../common/grizz-keyboard.nix
  ];

  nix = nixSettings.system { inherit pkgs; };

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
    extraGroups = [ "wheel" "networkmanager" ];
    packages = [ home-manager.packages.${pkgs.system}.default ];
  };

  system.stateVersion = "23.05";
}
