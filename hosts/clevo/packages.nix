{ pkgs, ... }@inputs:
{
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    inputs.grizz-zfs-diff

    # backlight
    brightnessctl
    light
    xorg.xset
  ];
  programs.hyprland.enable = true;
}
