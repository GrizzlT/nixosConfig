{ config, pkgs, lib, ... }@inputs:
let
  hostName = "clevo";
  hostId = "13eb44cc";
in
{
  imports = [
    ./hardware.nix
    ./persist.nix
  ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.hostId = hostId;
  networking.hostName = hostName;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Brussels";

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    inputs.grizz-zfs-diff
  ];

  users.mutableUsers = false;
  users.users.grizz = {
    passwordFile = "/persist/users/grizz/passwordFile";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = [ ];
  };

  system.stateVersion = "23.05";
}
