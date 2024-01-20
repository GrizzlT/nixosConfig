{ pkgs, inputPkgs, selfPkgs, ... }:
{
  # Very basic packages + packages requiring system access
  environment.systemPackages = with pkgs; [
    # minimal basics
    vim
    wget
    curl
    git
    selfPkgs.grizz-zfs-diff

    inputPkgs.agenix.default
  ];
}
