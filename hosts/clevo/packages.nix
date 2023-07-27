{ pkgs, hyprland, ... }@inputs:
{
  environment = {
    systemPackages = with pkgs; [
      # minimal basics
      vim
      wget
      curl
      git
      inputs.grizz-zfs-diff
    ];
  };
  programs.light.enable = true;

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.etc."pam.d/swaylock".text = ''auth include login'';

  programs.zsh = {
    enable = true;
  };
}
