{ pkgs, ... }:
{
  services.xserver.xkb = {
    layout = "grizz";
    options = "ctrl:nocaps";
    extraLayouts = {
      "grizz" = {
        languages = [ "nld" ];
        symbolsFile = ./grizz-keyboard.xkb;
        description = "Grizz's personal coding layout";
      };
      "grizz-gaming" = {
        languages = [ "nld" ];
        symbolsFile = ./grizz-keyboard-gaming.xkb;
        description = "Grizz's personal gaming layout";
      };
    };
  };

  console.useXkbConfig = true;
}
