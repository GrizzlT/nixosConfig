final: prev: let
  toolchain = prev.inputPkgs.fenix.fenix.stable.minimalToolchain;
  rustPlatform = prev.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in {
  emoji-fzf = final.callPackage ./emoji-fzf.nix {};
  porsmo = final.callPackage ./porsmo.nix { inherit rustPlatform; };
  awatcher = final.callPackage ./awatcher.nix { inherit rustPlatform; };
  paperage = final.callPackage ./paperage.nix { inherit rustPlatform; };

  neovim = prev.callPackage ./neovim/eval.nix {
    vimExtraPlugins = prev.inputPkgs.vimExtraPlugins;
  };
}
