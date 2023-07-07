{ pkgs, ... }@inputs:
{
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    inputs.grizz-zfs-diff

    # hyprland
    wev
  ];
  programs.hyprland.enable = true;
}
