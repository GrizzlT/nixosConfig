{
  description = "GrizzlT's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/603de16f9a98688b79f19baa24d6e2c0346545f5";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix/5c829554280f3139ddbfce8561d7430efbf2abfb";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    packages = nixpkgs.lib.recursiveUpdate (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: import ./linux-packages {
      inherit self;
      pkgs = nixpkgs.legacyPackages.${system};
      flake-inputs = inputs;
    })) (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ] (system: import ./packages {
      inherit self;
      pkgs = nixpkgs.legacyPackages.${system};
      flake-inputs = inputs;
    }));

    nixosConfigurations."clevo" = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        grizz-zfs-diff = self.packages.${system}.grizz-zfs-diff;
        inherit home-manager;
        inherit (inputs) hyprland stylix;
      };
      modules = [
        inputs.hyprland.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
        ./hosts/clevo/configuration.nix
      ];
    };

    homeConfigurations."grizz@clevo" = let pkgs = nixpkgs.legacyPackages."x86_64-linux"; in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
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
