inputs:
self: super: {
  grizz-disk-setup = self.callPackage ./grizz-disk-setup.nix {};
  grizz-zfs-diff = self.callPackage ./grizz-zfs-diff.nix {};
}
