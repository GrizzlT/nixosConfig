{ buildEnv, mkShell, writeShellScriptBin }:
({
  name,
  nativeBuildInputs ? [],
  buildInputs ? [],
  basePathEnv ? "GRIZZ_PROFILES",
  ...
}@args:

let
  args' = builtins.removeAttrs args [ "basePathEnv" ];

  env = buildEnv (args' // {
    name = "profile-${name}";
  });
in
env // {
  switch = writeShellScriptBin "switch" ''
    nix-env --set ${env} "$@" --profile ''${${basePathEnv}:-.}/${name}
  '';
  rollback = writeShellScriptBin "rollback" ''
    nix-env --rollback "$@" --profile ''${${basePathEnv}:-.}/${name}
  '';
  shell = mkShell {
    buildInputs = args'.buildInputs ++ args'.paths;
    nativeBuildInputs = args'.nativeBuildInputs;
  };
})
