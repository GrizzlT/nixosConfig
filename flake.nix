{
  description = "GrizzlT's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakeSecrets = {
      url = "git+file:./flakeSecrets?shallow=1";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.31.0";
      inputs.nixpkgs.follows = "unstable";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "unstable";
    };

    stylix = {
      url = "github:danth/stylix/5c829554280f3139ddbfce8561d7430efbf2abfb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
      ref = "master";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
  let
    flakeOverlay = final: prev: {
      unstable = import unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
    pkgs = system: import nixpkgs { overlays = [
      flakeOverlay
      inputs.nixneovimplugins.overlays.default
      inputs.hyprland-contrib.overlays.default
    ]; inherit system; };
  in {
    packages = nixpkgs.lib.recursiveUpdate (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ] (system: import ./linux-packages {
      inherit self;
      pkgs = pkgs system;
      flake-inputs = inputs;
    })) (nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ] (system: import ./packages {
      inherit self;
      pkgs = pkgs system;
      flake-inputs = inputs;
    }));

    nixosConfigurations."clevo" = let system = "x86_64-linux"; in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        grizz-zfs-diff = self.packages.${system}.grizz-zfs-diff;
        inherit home-manager;
        inherit (inputs) hyprland stylix agenix;
      };
      modules = [
        inputs.impermanence.nixosModules.impermanence
        inputs.agenix.nixosModules.default
        ./hosts/clevo
        { nixpkgs.overlays = [ flakeOverlay ]; }
      ];
    };

    homeConfigurations."grizz@clevo" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs "x86_64-linux";
        extraSpecialArgs = inputs;
        modules = [
          inputs.flakeSecrets.homeManagerModules.default
          ./home/base
          ./home/desktop/wm
          ./home/desktop/apps
          ({ pkgs, lib, ... }: {
            home = {
              username = "grizz";
              homeDirectory = "/home/grizz";
              stateVersion = "23.05";
            };
          })
        ];
    };
  };
}
