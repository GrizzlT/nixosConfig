{
  self,
  pkgs,
  flake-inputs,
}:
{
  emoji-fzf = pkgs.callPackage ./emoji-fzf.nix {};

  grizz-disk-setup = pkgs.callPackage ./grizz-disk-setup.nix {};
  grizz-zfs-diff = pkgs.callPackage ./grizz-zfs-diff.nix {};

  grizz-installer-iso = import ./grizz-installer.nix {
    inherit self;
    inherit pkgs;
    inherit (flake-inputs) nixos-generators;
  };
}
