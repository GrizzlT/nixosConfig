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
    pantheon.pantheon-agent-polkit
  ];
  programs.hyprland.enable = true;
}
