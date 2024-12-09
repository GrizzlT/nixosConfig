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
        spicetify = true;
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
      installer = {};
    };

    overlays.default = nixpkgs.lib.composeManyExtensions [
      inputs.rust-overlay.overlays.default
      (import ./packages/linux-only inputs)
      (import ./packages/universal inputs)
    ];

    inherit lib;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowcicles = {
      url = "github:GrizzlT/snowcicles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "unstable";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.45.2";

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "https://flakehub.com/f/nix-community/impermanence/0.1.tar.gz";

    rust-overlay.url = "github:oxalica/rust-overlay";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not flakes
    wezterm.url = "git+https://github.com/wez/wezterm.git?dir=nix&rev=6f375e29a2c4d70b8b51956edd494693196c6692";

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
