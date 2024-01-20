{
  description = "GrizzlT's NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: let
    lib = import ./lib.nix { inherit (nixpkgs) lib; };

    selfNixos = import ./modules/nixos;
    selfHm = import ./modules/hm;

    mkNixosConfig = { hostname, system }: (nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = (lib.extractInputs system inputs) // {
        selfPkgs = self.packages.${system};
        inherit selfNixos;
      };
      modules = [(./hosts/${hostname})];
    });

    mkHmConfig = { hostname, system }: (inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = inputs // (lib.extractInputs system inputs) // {
        unstable = import inputs.unstable {
          inherit system;
          config.allowUnfree = true;
        };
        selfPkgs = self.packages.${system};
        inherit selfHm;
      };
      modules = [(./home/grizz + "@${hostname}")];
    });
  in {
    packages = import ./packages {
      inherit nixpkgs;
      inputs = inputs // { inherit selfNixos; };
    };

    homeConfigurations."grizz@clevo" = mkHmConfig {
      hostname = "clevo";
      system = "x86_64-linux";
    };

    nixosConfigurations.clevo = mkNixosConfig {
      hostname = "clevo";
      system = "x86_64-linux";
    };
  };

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.tar.gz";
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.2311.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakeSecrets.url = "git+file:./flakeSecrets?shallow=1";

    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.34.tar.gz";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "unstable";
    };
    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland/v1.3.1";
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
}
