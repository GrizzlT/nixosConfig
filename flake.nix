{
  description = "GrizzlT's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
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

    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.inputs.systems.follows = "systems";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-utils, ... }@inputs: flake-utils.lib.meld inputs [
    ./packages
    ./hosts
  ];
}
