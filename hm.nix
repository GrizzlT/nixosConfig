let
  outputs = builtins.getFlake (toString ./.);
  # pkgs = outputs.inputs.nixpkgs;
  # drvs = pkgs.lib.collect pkgs.lib.isDerivation outputs.hydraJobs;
in [
  outputs.homeConfigurations."grizz@clevo".activationPackage
]
