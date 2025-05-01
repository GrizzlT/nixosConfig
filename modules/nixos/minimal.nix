{ pkgs, ... }:
{
  # Very basic packages + packages requiring system access
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    git-filter-repo
    grizz-zfs-diff

    agenix
  ];

  programs.nix-ld.enable = true;
}
