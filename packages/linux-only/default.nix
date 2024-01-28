final: prev: {
  grizz-disk-setup = final.callPackage ./grizz-disk-setup.nix {};
  grizz-zfs-diff = final.callPackage ./grizz-zfs-diff.nix {};
}
