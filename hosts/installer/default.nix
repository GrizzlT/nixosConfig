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

    age
    rage
    passage
  ];

  # Useless filesystem that gets overriden
  fileSystems."/" = {
    device = "/nodev";
    fsType = "auto";
  };

  boot.loader.grub.device = "nodev";

  system.stateVersion = "24.05";
}
