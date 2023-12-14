{ resholve, bash, zfs, coreutils }:
resholve.writeScriptBin "grizz-zfs-diff" {
  inputs = [ zfs coreutils ];
  interpreter = "${bash}/bin/bash";
  execer = [ "cannot:${zfs}/bin/zfs" ];
} (builtins.readFile ../scripts/grizz-zfs-diff.sh)
