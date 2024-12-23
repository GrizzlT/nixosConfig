{ pkgs, lib, ... }:
let
  common = import ../../modules/hm;

  headlessModules = builtins.attrValues common.headless;
  desktopModules = builtins.attrValues common.desktop;
in
{
  imports = headlessModules ++ desktopModules ++ [
    ./wm
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "obsidian"
      "spotify"
      "discord"
      "lunarclient"
    ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  home = {
    username = "grizz";
    homeDirectory = "/home/grizz";

    packages = with pkgs; [
      xdg-utils
    ];

    stateVersion = "23.11";
  };
}
