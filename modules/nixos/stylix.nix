{ pkgs, config, inputNixos, ... }:
{
  imports = [
    inputNixos.stylix.stylix
  ];

  fonts.packages = with pkgs; [ courier-prime ];

  stylix = {
    image = ../../wallpapers/sunset-1920x1080.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/snazzy.yaml";
    fonts = {
      monospace = {
        package = (pkgs.nerdfonts.override { fonts = [ "Hack" ]; });
        name = "Hack Nerd Font Mono";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    autoEnable = false;
    targets.gtk.enable = true;
  };
}
