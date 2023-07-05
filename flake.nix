{
  description = "GrizzlT's NixOS flake";

  inputs = {
    # Official NixOS package source, using nixos-unstable branch here
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

  outputs = { self, nixpkgs, impermanence, ... }@inputs: {
    nixosConfigurations = {
      "clevo" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          impermanence.nixosModules.impermanence
          # Import the configuration.nix we used before, so that the old configuration file can still take effect.
          # Note: /etc/nixos/configuration.nix itself is also a Nix Module, so you can import it directly here
          ./hosts/clevo/configuration.nix
        ];
      };
    };
  };
}
