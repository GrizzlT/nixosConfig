{ pkgs, hyprland, ... }@inputs:
{
  environment = {
    shells = with pkgs; [ bash zsh ];
    systemPackages = with pkgs; [
      # minimal basics
      vim
      wget
      curl
      git
      inputs.grizz-zfs-diff

      # # backlight
      # brightnessctl

      # polkit agent
      # mate.mate-polkit
    ];
  };
  programs.light.enable = true;

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.etc."pam.d/swaylock".text = ''auth include login'';
}
