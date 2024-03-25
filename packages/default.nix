{ self, nixpkgs }:
let
  forSystem = system: import nixpkgs { inherit system; overlays = [ self.overlays.default self.overlays.profiles ]; };
in
nixpkgs.lib.recursiveUpdate (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: let pkgs = forSystem system; in {
  inherit (pkgs) grizz-disk-setup grizz-zfs-diff;
})) (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ] (system: let pkgs = forSystem system; in {
  inherit (pkgs) emoji-fzf porsmo awatcher paperage neovim;
  inherit (pkgs.profiles) c python typescript web pwn crypto forensics misc audio hardware vpn typst-profile;
}))
