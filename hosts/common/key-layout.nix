{ pkgs, ... }:
{
  services.xserver = {
    layout = "grizz";
    xkbOptions = "ctrl:nocaps,shift:both_capslock";
    extraLayouts."grizz" = {
      languages = [ "nld" ];
      symbolsFile = ./grizz-keyboard;
      description = "Grizz's personal coding layout";
    };
  };

  console.useXkbConfig = true;
}
