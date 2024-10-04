{ resholve, bash, parted, zfs, coreutils, dosfstools, util-linux, cryptsetup }:
resholve.writeScriptBin "grizz-disk-setup" {
  inputs = [ parted zfs coreutils dosfstools util-linux cryptsetup ];
  interpreter = "${bash.out}/bin/bash";
  execer = [ "cannot:${util-linux.bin}/bin/swapon" "cannot:${zfs.out}/bin/zpool" "cannot:${zfs.out}/bin/zfs" ];
  fix = { mount = true; };
} (builtins.readFile ./scripts/grizz-disk-setup.sh)
