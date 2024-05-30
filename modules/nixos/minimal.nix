{ pkgs, ... }:
{
  # Very basic packages + packages requiring system access
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    grizz-zfs-diff

    agenix
  ];
}
