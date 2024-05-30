{
  description = "GrizzlT's NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: let
    lib = import ./lib.nix inputs;
  in {
    packages = import ./packages inputs;

    homeConfigurations = lib.mkHm {
      grizz = {
        modules = [
          inputs.stylix.homeManagerModules.stylix
        ];
        hyprland = true;
      };
    };

    nixosConfigurations = lib.mkNixOS {
      clevo = {
        modules = [
          inputs.impermanence.nixosModules.impermanence
          inputs.stylix.nixosModules.stylix
        ];
        hyprland = true;
      };
    };

    overlays.default = nixpkgs.lib.composeManyExtensions [
      (import ./packages/linux-only inputs)
      (import ./packages/universal inputs)
    ];
    overlays.profiles = nixpkgs.lib.composeManyExtensions [
      inputs.agenix.overlays.default
      (import ./profiles/overlay.nix)
    ];

    inherit lib;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "https://flakehub.com/f/nix-community/home-manager/0.2311.tar.gz";
      url = "github:GrizzlT/home-manager/release-23.11-patched";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowcicles = {
      url = "github:GrizzlT/snowcicles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "unstable";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.33.1";

    stylix = {
      url = "github:danth/stylix/9bc1900b6888efdda39c2e02c7c8666911b72608";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/0.1.tar.gz";

    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
