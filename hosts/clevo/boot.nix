{ config, lib, modulesPath, pkgs, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" "aesni_intel" "cryptd" ];
      kernelModules = [ "dm-snapshot" ];
      # devices must be alphabetical!!!
      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/1575133b-1dc4-49fc-83b0-d5c21eaed2f2";
	  # crypttabExtraOpts = [ "tpm2-device=auto" ];
        };
      };
    };

    loader = {
      limine = {
        enable = true;
	secureBoot.enable = false;
      };
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
    };

    supportedFilesystems.xfs = true;
    kernelModules = [ "kvm-intel" "i915" "v4l2loopback" "snd-aloop" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=2 video_nr=9,10 card_label="Android Cam","OBS Cam" exclusive_caps=1
      options snd slots=snd-hda-intel,snd-aloop,snd-aloop
      options snd-aloop index=1,2 pcm_substreams=2,2
    '';
  };

  systemd.enableEmergencyMode = false;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.tpm2-tools
    pkgs.lvm2
    pkgs.cryptsetup
  ];

  fileSystems."/" =
    { device = "/dev/vg0/root";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A0DD-5D1F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/vg0/swap"; }
    ];
}
