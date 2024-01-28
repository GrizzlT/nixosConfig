{ lib }:
with lib.attrsets;
let
  wrapOverlay = name: overlay: final: prev: {
    inputPkgs = (prev.inputPkgs or {}) // (overlay final prev);
  };

  inputsToOverlays = inputs: (lib.trivial.pipe inputs [
    (filterAttrs (_: v: v ? "overlays" && v.overlays ? "default"))
    (mapAttrs (n: v: wrapOverlay n v.overlays.default))
    (a: lib.composeManyExtensions (lib.mapAttrsToList (_: v: v) a))
  ]);

  inputsToNixosModules = inputs: lib.trivial.pipe inputs [
    (filterAttrs (_: v: v ? "nixosModules"))
    (mapAttrs (_: v: v.nixosModules))
    (mapAttrsToList (_: v: v))
    # (v: { inputNixos = v; })
  ];
  inputsToHmModules = inputs: lib.trivial.pipe inputs [
    (filterAttrs (_: v: v ? "homeManagerModules"))
    (mapAttrs (_: v: v.homeManagerModules))
    (mapAttrsToList (_: v: v))
    # (v: { inputHm = v; })
  ];

  depInjectModule = { pkgs, lib, ... }: {
    options.dep-inject = lib.mkOption {
      type = with lib.types; attrsOf unspecified;
      default = {};
    };
  };
in
{
  inherit inputsToNixosModules inputsToHmModules inputsToOverlays;

  mkNixosConfig = self: inputs: modules: { hostname, system }: (inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      (./hosts/${hostname})
      ({ pkgs, lib, ... }: {
        imports = modules;
        nixpkgs.overlays = [ self.overlays.default ];
      })
    ];
  });

  mkHmConfig = self: inputs: modules: { hostname, system }: (inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    modules = [
      (./home/grizz + "@${hostname}")
      depInjectModule
      ({ pkgs, lib, ... }: {
        imports = modules;
        nixpkgs.overlays = [
          self.overlays.default
          (final: prev: {
            unstable = import inputs.unstable { inherit system; config.allowUnfree = true; overlays = [ self.overlays.default ]; };
          })
        ];
      })
    ];
  });
}
