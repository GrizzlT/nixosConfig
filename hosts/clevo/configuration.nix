{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  systemd.enableEmergencyMode = false;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nohibernate" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    if test -d "/persist"; then
      systemd-cat echo "Persistence at boot works! Grizz"
    fi
  '';
#   zfs rollback -r storage/local/root@blank
# '';

  networking.hostId = "13eb44cc";
  networking.hostName = "clevo";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Brussels";

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];

  users.users.grizz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = [ ];
  };

  system.stateVersion = "23.05";
}
