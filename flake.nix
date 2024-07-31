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
        hosts.clevo = "x86_64-linux";
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

    inherit lib;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowcicles = {
      url = "github:GrizzlT/snowcicles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "unstable";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.41.2";

    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/0.1.tar.gz";

    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not flakes
    wezterm.url = "git+https://github.com/wez/wezterm.git?dir=nix&rev=56a27e93a9ee50aab50ff4d78308f9b3154b5122";
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://grizzlt.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "grizzlt.cachix.org-1:lbv8MslmgTPRlv1feXuGU+VUnEO92XKeedLeiv4ckIE="
    ];
  };
}
