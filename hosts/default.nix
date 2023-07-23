{ self, nixpkgs, ... }@inputs:
{
  "clevo" = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      grizz-zfs-diff = self.packages.${system}.grizz-zfs-diff;
      hyprland = inputs.hyprland;
      anyrun = inputs.anyrun;
      inherit inputs;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.hyprland.nixosModules.default
      inputs.impermanence.nixosModules.impermanence
      ./clevo/configuration.nix
    ];
  };
}
