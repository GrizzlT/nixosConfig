{ pkgs, lib, config, ... }:
let
  user = config.grizz.settings.user;
in
{
  grizz.settings.user = lib.mkDefault "grizz";

  users.mutableUsers = false;
  users.users.${user} = {
    hashedPasswordFile = "/persist/users/${user}/passwordFile";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "wireshark" "disk" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };

  environment.systemPackages = [ config.boot.kernelPackages.perf pkgs.perf-tools pkgs.valgrind ];

  programs.light.enable = true;

  # My window manager of choice
  programs.hyprland = {
    enable = true;
  };

  # Necessary for swaylock
  security.pam.services.swaylock = {};

  services.flatpak.enable = true;

  # Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;
}
