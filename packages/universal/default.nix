inputs:
self: super: let
  toolchain = (inputs.fenix.overlays.default self super).fenix.stable.minimalToolchain;
  rustPlatform = super.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in {
  emoji-fzf = self.callPackage ./emoji-fzf.nix {};
  porsmo = self.callPackage ./porsmo.nix { inherit rustPlatform; };
  awatcher = self.callPackage ./awatcher.nix { inherit rustPlatform; };
  paperage = self.callPackage ./paperage.nix { inherit rustPlatform; };

  wezterm = inputs.wezterm.packages.${self.system}.default;
}
