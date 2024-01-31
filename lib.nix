{ lib }:
{
  mkNixosConfig = self: inputs: modules: overlays: { hostname, system }: (inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      (./hosts/${hostname})
      ({ pkgs, lib, ... }: {
        imports = modules;
        nixpkgs.overlays = overlays;
      })
    ];
  });

  mkHmConfig = self: inputs: modules: overlays: { hostname, system }: (inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    modules = [
      (./home/grizz + "@${hostname}")
      ({ pkgs, lib, ... }: {
        imports = modules;
        nixpkgs.overlays = overlays;
      })
    ];
  });
}
