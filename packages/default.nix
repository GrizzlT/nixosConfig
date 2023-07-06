{ self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      packages = {
        grizz-disk-setup = import ./grizz-disk-setup.nix { inherit pkgs; };
        grizz-zfs-diff = import ./grizz-zfs-diff.nix { inherit pkgs; };
      };
    }
  )
