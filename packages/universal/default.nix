{ pkgs, inputs }:
let
  toolchain = inputs.fenix.packages.${pkgs.system}.minimal.toolchain;
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
{
  emoji-fzf = pkgs.callPackage ./emoji-fzf.nix {};
  porsmo = pkgs.callPackage ./porsmo.nix {};
  awatcher = pkgs.callPackage ./awatcher.nix { inherit rustPlatform; };

  neovim = pkgs.callPackage ./neovim {
    vimExtraPlugins = inputs.nixneovimplugins.packages.${pkgs.system};
  };
}
