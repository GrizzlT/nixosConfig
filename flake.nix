{
  description = "GrizzlT's NixOS flake";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.tar.gz";
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.2311.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakeSecrets = {
      url = "git+file:./flakeSecrets?shallow=1";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.33.tar.gz";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "unstable";
    };
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland/v1.2.6";
      inputs.nixpkgs.follows = "unstable";
    };

    stylix = {
      url = "https://flakehub.com/f/danth/stylix/0.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/0.1.tar.gz";

    agenix = {
      url = "https://flakehub.com/f/ryantm/agenix/0.14.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "https://flakehub.com/f/nix-community/nixos-generators/0.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.tar.gz";
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
        inherit (inputs) hyprland stylix agenix xdg-portal-hyprland;
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
              stateVersion = "23.11";
            };
          })
        ];
    };
  };
}
