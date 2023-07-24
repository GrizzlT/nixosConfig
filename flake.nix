{
  description = "GrizzlT's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
      ref = "master";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    packages = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: import ./packages {
      inherit self;
      pkgs = nixpkgs.legacyPackages.${system};
      flake-inputs = inputs;
    });

    nixosConfigurations."clevo" = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        grizz-zfs-diff = self.packages.${system}.grizz-zfs-diff;
        inherit home-manager;
      };
      modules = [
        inputs.hyprland.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
        ./hosts/clevo/configuration.nix
      ];
    };

    homeConfigurations."grizz@clevo" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = inputs;
      modules = [
        ./home/base
        ./home/desktop
        {
          home = {
            username = "grizz";
            homeDirectory = "/home/grizz";
            stateVersion = "23.05";
          };
        }
      ];
    };
  };
}
