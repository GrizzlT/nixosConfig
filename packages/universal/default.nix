inputs:
self: super: let
  vimExtraPlugins = (inputs.nixneovimplugins.overlays.default self super).vimExtraPlugins;
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

  neovim = super.callPackage ./neovim/eval.nix { inherit vimExtraPlugins; };
}
