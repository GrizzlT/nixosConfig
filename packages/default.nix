{ nixpkgs, inputs, }:
let
  pkgs = system: nixpkgs.legacyPackages.${system};

  universal = { pkgs, inputs }: (import ./universal) { inherit pkgs inputs; };
  linux-only = { pkgs, inputs }: (import ./linux-only) { inherit pkgs inputs; };
in
nixpkgs.lib.recursiveUpdate (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: linux-only {
  pkgs = pkgs system;
  inherit inputs;
})) (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ] (system: universal {
  pkgs = pkgs system;
  inherit inputs;
}))
