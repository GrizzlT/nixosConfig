{ config, lib, modulesPath, ... }:
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

      postResumeCommands = lib.mkAfter ''
        cryptsetup close cryptkey
        zfs rollback -r ${zpool}/local/root@blank && echo blanked out root
      '';
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
    };

    supportedFilesystems.zfs = true;
    kernelParams = [ "nohibernate" ];
    kernelModules = [ "kvm-intel" "i915" "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
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
}
