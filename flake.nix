{
  description = "GrizzlT's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # # home-manager, used for managing user configuration
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-22.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
      ref = "master";
    };
  };

  outputs = { self, nixpkgs, impermanence, ... }@inputs:
  {
    nixosConfigurations = {
      "clevo" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          impermanence.nixosModules.impermanence
          ./hosts/clevo/configuration.nix
        ];
      };
    };
  };
}
