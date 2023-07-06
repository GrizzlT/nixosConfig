{ self, nixpkgs, impermanence, nixos-generators, ... }@input: {
  nixosConfigurations = {
    "clevo" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = self.packages.x86_64-linux.grizz-zfs-diff;
      modules = [
        impermanence.nixosModules.impermanence
          ./clevo/configuration.nix
      ];
    };
  };

  packages.x86_64-linux.myInstaller = nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    format = "iso";
    pkgs = input.nixpkgs-stable.legacyPackages.x86_64-linux;
    lib = input.nixpkgs-stable.legacyPackages.x86_64-linux.lib;
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
