{ pkgs, ... }:
let
  my-name = "grizz-zfs-diff";
  my-buildInputs = with pkgs; [ zfs coreutils ];
  my-script = (pkgs.writeScriptBin my-name (builtins.readFile ../scripts/grizz-zfs-diff.sh)).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in pkgs.symlinkJoin {
  name = my-name;
  paths = [ my-script ] ++ my-buildInputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
}
