{ pkgs, ... }:
{
  services.xserver = {
    layout = "grizz";
    extraLayouts."grizz" = {
      languages = [ "nld" ];
      symbolFile = ./grizz-keyboard;
      description = "Grizz's personal coding layout";
    };
  };
}
