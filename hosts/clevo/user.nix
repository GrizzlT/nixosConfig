userName:
{ pkgs, ... }:
{
  users.mutableUsers = false;
  users.users.${userName} = {
    hashedPasswordFile = "/persist/users/${userName}/passwordFile";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };

  programs.light.enable = true;

  # My window manager of choice
  programs.hyprland = {
    enable = true;
  };

  # Necessary for swaylock
  environment.etc."pam.d/swaylock".text = ''auth include login'';

  # Gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Shell
  programs.zsh.enable = true;
  programs.fish.enable = true;
}
