{ resholve, bash, parted, zfs, coreutils, dosfstools, util-linux, cryptsetup }:
resholve.writeScriptBin "grizz-disk-setup" {
  inputs = [ parted zfs coreutils dosfstools util-linux cryptsetup ];
  interpreter = "${bash}/bin/bash";
  execer = [ "cannot:${util-linux}/bin/swapon" ];
  fix = { mount = true; };
} (builtins.readFile ../scripts/grizz-disk-setup.sh)
