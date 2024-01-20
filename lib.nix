{ lib }:
with lib.attrsets;
let
  inputsToPkgs = system: inputs: (lib.trivial.pipe inputs [
    (filterAttrs (_: v: v ? "packages" && v.packages ? "${system}"))
    (mapAttrs (_: v: v.packages.${system}))
    (v: { inputPkgs = v; })
  ]);
  inputsToNixosModules = system: inputs: lib.trivial.pipe inputs [
    (filterAttrs (_: v: v ? "nixosModules"))
    (mapAttrs (_: v: v.nixosModules))
    (v: { inputNixos = v; })
  ];
  inputsToHmModules = system: inputs: lib.trivial.pipe inputs [
    (filterAttrs (_: v: v ? "homeManagerModules"))
    (mapAttrs (_: v: v.homeManagerModules))
    (v: { inputHm = v; })
  ];
in
{
  extractInputs = system: inputs:
    (inputsToPkgs system inputs)
      // (inputsToNixosModules system inputs)
      // (inputsToHmModules system inputs);
}
