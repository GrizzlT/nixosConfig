{ self, nixpkgs, nixos-generators, ... }@inputs: {
  nixosConfigurations = {
    "clevo" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        grizz-zfs-diff = self.packages.x86_64-linux.grizz-zfs-diff;
        hyprland = inputs.hyprland;
      };
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.hyprland.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
        ./clevo/configuration.nix
      ];
    };
  };

  packages.x86_64-linux.myInstaller = nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    format = "iso";
    specialArgs = let pkgs = self.packages.x86_64-linux; in
    with pkgs; {
      inherit grizz-disk-setup;
      inherit grizz-zfs-diff;
    };
    modules = [
      ./newSystem/configuration.nix
    ];
  };
}
