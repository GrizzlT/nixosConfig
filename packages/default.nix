{ self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; }; in
    {
      packages = {
        grizz-disk-setup = import ./grizz-disk-setup.nix { inherit pkgs; };
        grizz-zfs-diff = import ./grizz-zfs-diff.nix { inherit pkgs; };
      };
    }
  )
