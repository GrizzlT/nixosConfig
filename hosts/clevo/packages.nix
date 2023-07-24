{ pkgs, ... }@inputs:
{
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    inputs.grizz-zfs-diff

    # # backlight
    # brightnessctl

    # polkit agent
    mate.mate-polkit
  ];

  programs.hyprland.enable = true;

  environment.etc."pam.d/swaylock".text = ''auth include login'';
}
