inputs:
self: super: let
  toolchain = self.rust-bin.stable."1.96.0".minimal;
  rustPlatform = super.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in {
  emoji-fzf = self.callPackage ./emoji-fzf.nix {};
  porsmo = self.callPackage ./porsmo.nix { inherit rustPlatform; };
  awatcher = self.callPackage ./awatcher.nix { inherit rustPlatform; };
  paperage = self.callPackage ./paperage.nix { inherit rustPlatform; };
  cfait = self.callPackage ./cfait.nix { inherit rustPlatform; };
  rayfish = self.callPackage ./rayfish.nix { inherit rustPlatform; };
  tackler = self.callPackage ./tackler.nix { inherit rustPlatform; };

  hledger-lsp = self.callPackage ./hledger-lsp.nix {};

  # wezterm = inputs.wezterm.packages.${self.system}.default;

  xmcl = self.callPackage ./xmcl.nix {};
}
