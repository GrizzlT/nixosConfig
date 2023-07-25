{ pkgs, config, stylix, ... }:
{
  imports = [
    stylix.homeManagerModules.stylix
  ];

  stylix = {
    image = ../../wallpapers/color-bg.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/snazzy.yaml";
    fonts = {
      monospace = {
        package = (pkgs.nerdfonts.override { fonts = [ "Hack" ]; });
        name = "Hack Nerd Font Mono";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes.terminal = 13;
    };

    autoEnable = false;
    targets.gtk.enable = true;
    targets.waybar.enable = true;
    targets.wezterm.enable = true;
  };

  home.pointerCursor = {
    package = pkgs.phinger-cursors;
    name = "phinger-cursors";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "la-capitaine-icon-theme";
      package = pkgs.la-capitaine-icon-theme;
    };
  };
}
