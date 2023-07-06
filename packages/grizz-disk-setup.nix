{ pkgs, ... }:
let
  my-name = "grizz-disk-setup";
  my-buildInputs = with pkgs; [ parted zfs coreutils util-linux cryptsetup ];
  my-script = (pkgs.writeScriptBin my-name (builtins.readFile ../scripts/grizz-disk-setup.sh)).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in pkgs.symlinkJoin {
  name = my-name;
  paths = [ my-script ] ++ my-buildInputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
}
