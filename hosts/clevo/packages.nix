{ lib, pkgs, hyprland, ... }@inputs:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  # Very basic packages + packages requiring system access
  environment = {
    systemPackages = with pkgs; [
      # minimal basics
      vim
      wget
      curl
      git
      inputs.grizz-zfs-diff

      libimobiledevice
      ifuse
      nfs-utils
      cifs-utils
    ];
  };
  programs.light.enable = true;

  # My window manager of choice
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
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
