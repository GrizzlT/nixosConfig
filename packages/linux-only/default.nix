{ pkgs, inputs }:
let
  grizz-disk-setup = pkgs.callPackage ./grizz-disk-setup.nix {};
  grizz-zfs-diff = pkgs.callPackage ./grizz-zfs-diff.nix {};
in
{
  inherit grizz-disk-setup grizz-zfs-diff;

  grizz-installer-iso = import ./grizz-installer.nix {
    inherit pkgs;
    inherit (inputs) nixos-generators;
    grizzScripts = { inherit grizz-disk-setup grizz-zfs-diff; };
  };
}
