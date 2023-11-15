{
  self,
  pkgs,
  flake-inputs,
}:
{
  emoji-fzf = pkgs.callPackage ./emoji-fzf.nix {};
  porsmo = pkgs.callPackage ./porsmo.nix {};
  awatcher = pkgs.callPackage ./awatcher.nix {};

  neovim = pkgs.callPackage ./neovim { nixd = pkgs.unstable.nixd; };
}
