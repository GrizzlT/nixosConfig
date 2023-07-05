{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "storage/local/root";
    fsType = "zfs";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8D4A-271D";
    fsType = "vfat";
  };
  fileSystems."/nix" = {
    device = "storage/local/nix";
    fsType = "zfs";
  };
  fileSystems."/home" = {
    device = "storage/safe/home";
    fsType = "zfs";
  };
  fileSystems."/persist" = {
    device = "storage/safe/persist";
    fsType = "zfs";
    # neededForBoot = true;
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/279d69f6-8b53-4071-afa3-b1a91b925b0b"; } ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp46s0.useDHCP bla bla
  # networking.interfaces.wlp0s20f3.useDHCP bla bla

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
