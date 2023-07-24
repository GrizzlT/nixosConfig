{ config, pkgs, lib, modulesPath, ... }:
let
  deviceCryptKey = "/dev/disk/by-label/CRYPTKEY";
  deviceCryptRoot = "/dev/disk/by-label/CRYPTROOT";
  deviceBoot = "/dev/disk/by-label/BOOT";
  deviceSwap = "/dev/disk/by-partlabel/swap";
  zpool = "storage";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
      # devices must be alphabetical!!!
      luks.devices = {
        cryptkey = {
          device = deviceCryptKey;
        };
        cryptroot = {
          allowDiscards = true;
          device = deviceCryptRoot;
          keyFile = "/dev/mapper/cryptkey";
          keyFileSize = 8192;
        };
      };

      postDeviceCommands = lib.mkAfter ''
        cryptsetup close cryptkey
        zfs rollback -r ${zpool}/local/root@blank && echo blanked out root
      '';
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    kernelModules = [ "kvm-intel" "i915" ];
    extraModulePackages = [ ];
  };

  systemd.enableEmergencyMode = false;
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
    trim.enable = true;
  };

  fileSystems."/" = {
    device = "${zpool}/local/root";
    fsType = "zfs";
  };
  fileSystems."/boot" = {
    device = deviceBoot;
    fsType = "vfat";
  };
  fileSystems."/nix" = {
    device = "${zpool}/local/nix";
    fsType = "zfs";
  };
  fileSystems."/home" = {
    device = "${zpool}/safe/home";
    fsType = "zfs";
  };
  fileSystems."/persist" = {
    device = "${zpool}/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
  fileSystems."/var/lib" = {
    device = "${zpool}/safe/lib";
    fsType = "zfs";
  };
  fileSystems."/var/log/journal" = {
    device = "${zpool}/safe/journal";
    fsType = "zfs";
    neededForBoot = true;
  };

  swapDevices = [ { device = deviceSwap; randomEncryption = true; } ];

  # networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp46s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
