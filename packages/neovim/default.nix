{ pkgs, makeNixvimWithModule, ... }:
makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [
        ./options.nix
        ./autocmd.nix
        ./colorscheme.nix
        ./editor.nix
      ];

      clipboard.providers.wl-copy.enable = true;
      luaLoader.enable = true;
    };
  }
