{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/grizz-keyboard.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    grizz-disk-setup
    grizz-zfs-diff
    parted
    util-linux

    age
    rage
    passage

    nixos-install-tools

    restic
    cryptsetup
    sbctl

    libxfs
    dosfstools
    lvm2
    rclone

    tomb
  ];

  # Useless filesystem that gets overriden
  fileSystems."/" = {
    device = "/nodev";
    fsType = "auto";
  };

  boot.loader.grub.device = "nodev";

  system.stateVersion = "26.05";
}
