{ pkgs, anyrun, ... }:
let
  configPath = ".config/anyrun";
in
{
  home.packages = [ anyrun.packages.${pkgs.system}.stdin ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        anyrun.packages.${pkgs.system}.applications
        anyrun.packages.${pkgs.system}.dictionary
        anyrun.packages.${pkgs.system}.rink
        anyrun.packages.${pkgs.system}.shell
        anyrun.packages.${pkgs.system}.symbols
      ];
      width = { fraction = 0.3; };
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      ignoreExclusiveZones = false;
      hidePluginInfo = true;
      layer = "overlay";
      closeOnClick = true;
      showResultsImmediately = true;
    };
  };

  home.file."${configPath}/symbols.ron".source = ./symbols.ron;
}
