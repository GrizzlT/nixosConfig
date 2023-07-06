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
    settings = {
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking.hostId = hostId;
  networking.hostName = hostName;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    0.0.0.0 facebook.com m.facebook.com
  '';

  security.sudo.extraConfig = "Defaults lecture = never";

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
