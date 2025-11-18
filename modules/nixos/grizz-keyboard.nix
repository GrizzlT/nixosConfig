{ ... }:
{
  services.xserver.xkb = {
    layout = "grizz,us";
    options = "ctrl:nocaps";
    variant = ",intl";
    extraLayouts = {
      "grizz" = {
        languages = [ "nld" ];
        symbolsFile = ./keyboard/grizz-keyboard.xkb;
        description = "Grizz's personal coding layout";
      };
      "grizz-gaming" = {
        languages = [ "nld" ];
        symbolsFile = ./keyboard/grizz-keyboard-gaming.xkb;
        description = "Grizz's personal gaming layout";
      };
    };
  };

  console.useXkbConfig = true;
}
