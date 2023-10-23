{ pkgs, ... }@inputs:
let
  toolchain = inputs.fenix.packages.${pkgs.system}.minimal.toolchain;
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
{
  home.sessionVariables = {
    PASSAGE_DIR = "$HOME/DATA/.passage/store";
    PASSAGE_IDENTITIES_FILE = "$HOME/DATA/.passage/identities";
    PASSWORD_STORE_CLIP_TIME = 20;
    PASSWORD_STORE_GENERATED_LENGTH = 20;
  };

  home.packages = with pkgs; [
    passage
    age

    (callPackage ./paperage.nix { inherit rustPlatform; })

    (callPackage ({ writeShellApplication, findutils, passage, gnused, fzf }:
    writeShellApplication {
      name = "fzf-passage";
      runtimeInputs = [ findutils passage gnused fzf ];
      text = ''
        set -eou pipefail
        PREFIX="''${PASSAGE_DIR:-$HOME/.passage/store}"
        name="$(find "$PREFIX" -type f -name '*.age' | \
          sed -e "s|$PREFIX/||" -e 's|\.age$||' | \
          fzf --height 40% --reverse --no-multi)"
        passage "''${@}" "$name"
      '';
    }) {})
  ];
}
