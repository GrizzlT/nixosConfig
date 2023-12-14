userName:
{ pkgs, home-manager, hyprland, xdg-portal-hyprland, ... }:
{
  time.timeZone = "Europe/Brussels";
  i18n = {
    extraLocaleSettings = {
      LC_TIME = "nl_BE.UTF-8";
      LC_COLLATE = "nl_BE.UTF-8";
      LC_MONETARY = "nl_BE.UTF-8";
      LC_PAPER = "nl_BE.UTF-8";
      LC_NAME = "nl_BE.UTF-8";
      LC_ADDRESS = "nl_BE.UTF-8";
      LC_TELEPHONE = "nl_BE.UTF-8";
      LC_MEASUREMENT = "nl_BE.UTF-8";
      LC_IDENTIFICATION = "nl_BE.UTF-8";
    };
  };

  users.mutableUsers = false;
  users.users.${userName} = {
    hashedPasswordFile = "/persist/users/${userName}/passwordFile";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    packages = [ home-manager.packages.${pkgs.system}.default ];
    shell = pkgs.zsh;
  };

  programs.light.enable = true;

  # My window manager of choice
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = xdg-portal-hyprland.packages.${pkgs.system}.default;
  };

  # Necessary for swaylock
  environment.etc."pam.d/swaylock".text = ''auth include login'';

  # Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # The Z shell
  programs.zsh = {
    enable = true;
  };
}
