{ pkgs, ... }:
let
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${./grizz.xkb} $out
  '';
in
{
  services.xserver = {
    exportConfiguration = true;

    displayManager.sessionCommands =
      "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
  };
  console.useXkbConfig = true;
}
