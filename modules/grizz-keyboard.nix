{ pkgs, ... }:
{
  services.xserver = {
    layout = "grizz";
    xkbOptions = "ctrl:nocaps";
    extraLayouts."grizz" = {
      languages = [ "nld" ];
      symbolsFile = ./grizz-keyboard.xkb;
      description = "Grizz's personal coding layout";
    };
  };

  console.useXkbConfig = true;
}
