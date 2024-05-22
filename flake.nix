{
  description = "GrizzlT's NixOS flake";

  outputs = { self, nixpkgs, ... }@inputs: let
    lib = import ./lib.nix { inherit (nixpkgs) lib; };

    mkNixosConfig = lib.mkNixosConfig self inputs;
    mkHmConfig = lib.mkHmConfig self inputs;

    unstableOverlay = pkgs: pkgs0: {
      unstable = import inputs.unstable { inherit (pkgs0) system; config.allowUnfree = true; overlays = [ self.overlays.default ]; };
    };
  in {
    packages = import ./packages inputs;

    homeConfigurations."grizz@clevo" = mkHmConfig (with inputs; [
      stylix.homeManagerModules.stylix
    ]) (with inputs; [
      hyprland.overlays.default
      self.overlays.default
      unstableOverlay
    ]) {
      hostname = "clevo";
      system = "x86_64-linux";
    };

    nixosConfigurations.clevo = mkNixosConfig (with inputs; [
      agenix.nixosModules.default
      impermanence.nixosModules.impermanence
      stylix.nixosModules.stylix
    ]) (with inputs; [
      agenix.overlays.default
      hyprland.overlays.default
      xdg-portal-hyprland.overlays.default
      self.overlays.default
    ]) {
      hostname = "clevo";
      system = "x86_64-linux";
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
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";

    home-manager = {
      # url = "https://flakehub.com/f/nix-community/home-manager/0.2311.tar.gz";
      url = "github:GrizzlT/home-manager/release-23.11-patched";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.33.tar.gz";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "unstable";
    };
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland/v1.3.1";

    stylix = {
      url = "github:danth/stylix/9bc1900b6888efdda39c2e02c7c8666911b72608";
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
