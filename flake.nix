{
  description = "GrizzlT's NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: let
    lib = import ./lib.nix { inherit (nixpkgs) lib; };

    mkNixosConfig = lib.mkNixosConfig self inputs;
    mkHmConfig = lib.mkHmConfig self inputs;
  in {
    packages = import ./packages { inherit self nixpkgs; };

    homeConfigurations."grizz@clevo" = mkHmConfig (with inputs; [
      stylix.homeManagerModules.stylix
    ]) {
      hostname = "clevo";
      system = "x86_64-linux";
    };

    nixosConfigurations.clevo = mkNixosConfig (with inputs; [
      agenix.nixosModules.default
      impermanence.nixosModules.impermanence
      stylix.nixosModules.stylix
    ]) {
      hostname = "clevo";
      system = "x86_64-linux";
    };

    overlays.default = nixpkgs.lib.composeManyExtensions [
      (lib.inputsToOverlays inputs)
      inputs.hyprland.overlays.hyprland-packages # FIXME: hack until pr gets merged
      (import ./packages/linux-only)
      (import ./packages/universal)
    ];

    inherit lib;
  };

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.tar.gz";
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";

    home-manager = {
      # url = "https://flakehub.com/f/nix-community/home-manager/0.2311.tar.gz";
      url = "github:GrizzlT/home-manager/release-23.11-patched";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flakeSecrets.url = "git+file:./flakeSecrets?shallow=1";

    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.33.tar.gz";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "unstable";
    };
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland/v1.3.1";

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
