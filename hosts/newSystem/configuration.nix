{ config, pkgs, lib, options, ... }@inputs:
{
  imports = [
    ./installation-cd-minimal.nix
    ../common/key-layout.nix
  ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.git
    pkgs.zfs
    inputs.grizz-disk-setup
    inputs.grizz-zfs-diff
  ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
