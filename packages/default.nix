{
  self,
  pkgs,
  flake-inputs,
}:
let
  makeNixvimWithModule = flake-inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule;
in
{
  emoji-fzf = pkgs.callPackage ./emoji-fzf.nix {};

  neovim = import ./neovim { inherit pkgs makeNixvimWithModule; };
}
