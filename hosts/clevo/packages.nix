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

    # polkit agent
    libsForQt5.polkit-kde-agent
  ];
  programs.hyprland.enable = true;
}
