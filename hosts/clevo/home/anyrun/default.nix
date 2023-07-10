{ pkgs, anyrun, ... }:
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
      y = { absolute = 10; };
      ignoreExclusiveZones = false;
      layer = "overlay";
      closeOnClick = true;
      showResultsImmediately = true;
    };
  };
}
