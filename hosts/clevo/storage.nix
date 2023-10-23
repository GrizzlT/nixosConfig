{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bashmount
    # iPhone
    libimobiledevice
    ifuse
    # NFS
    nfs-utils
    # Samba
    cifs-utils
    # SSHFS
    sshfs
  ];

  environment.etc."bashmount.conf".text = ''
    mount_options='--options noexec,noatime'
  '';

  fileSystems.backupDrive = {
    mountPoint = "/mnt/BackupDrive";
    fsType = "ext4";
    device = "/dev/disk/by-uuid/101ed7ea-e9da-4c38-bc55-cabfa9f0455f";
    options = [
      "rw"
      "suid"
      "dev"
      "user"
      "async"
      "noauto"
      "noexec"
      "noatime"
      "data=journal"
    ];
  };

  # Iphone mounting
  services.usbmuxd.enable = true;
  services.rpcbind.enable = true;

  # CIFS, NFS
  boot.supportedFilesystems = [ "cifs" "nfs" "sshfs" ];
}
