{ pkgs, ... }:
{
  services.xserver.extraLayouts.grizz = {
    languages = [ "nld" ];
    symbolFile = ./grizz-keyboard;
    description = "Grizz's personal coding layout";
  };
}
