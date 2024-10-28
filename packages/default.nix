{ self, nixpkgs, ... }@inputs:
let
  profiles = import "${self}/profiles" inputs;

  forSystem = system: import nixpkgs {
    inherit system;
    overlays = [
      self.overlays.default
      (self: super: {
        unstable = import inputs.unstable {
          inherit system;
          overlays = [
            self.overlays.default
          ] ++ profiles.overlays;
        };
      })
    ] ++ profiles.overlays;
    config.allowUnfreePredicate = pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "ngrok"
      ];
  };
in
nixpkgs.lib.recursiveUpdate (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: let pkgs = forSystem system; in {
  inherit (pkgs) grizz-disk-setup grizz-zfs-diff;
})) (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ] (system: let pkgs = forSystem system; in {
  inherit (pkgs) emoji-fzf porsmo awatcher paperage neovim;
} // (profiles.profiles pkgs)))
