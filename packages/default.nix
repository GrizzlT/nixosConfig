{
  self,
  pkgs,
  flake-inputs,
}:
{
  emoji-fzf = pkgs.callPackage ./emoji-fzf.nix {};

  neovim = pkgs.callPackage ./neovim {};
}
