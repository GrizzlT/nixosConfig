{ pkgs, ... }:
{
  services.xserver = {
    layout = "grizz";
    extraLayouts."grizz" = {
      languages = [ "nld" ];
      symbolsFile = ./grizz-keyboard;
      description = "Grizz's personal coding layout";
    };
  };
}
