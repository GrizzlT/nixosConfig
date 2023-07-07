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
    # temporary
    wev
  ];
  programs.hyprland.enable = true;
}
