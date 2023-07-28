{ pkgs, makeNixvimWithModule, ... }:
makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [
        ./options.nix
      ];
    };
  }
