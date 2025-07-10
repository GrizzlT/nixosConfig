{ pkgs, config, ... }:
{
  stylix = {
    enable = true;
    image = ../../../wallpapers/sunset-1920x1080.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/snazzy.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes.terminal = 13;
      sizes.desktop = 12;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
    };
    # iconTheme = {
    #   enable = true;
    #   light = "la-capitaine-icon-theme";
    #   package = pkgs.la-capitaine-icon-theme;
    # };

    autoEnable = false;
    targets.gtk.enable = true;
    targets.waybar.enable = true;
    targets.wezterm.enable = true;
    targets.foot.enable = true;
    targets.dunst.enable = true;
    targets.swaylock.enable = true;
    targets.bemenu.enable = true;
    targets.bat.enable = true;
    targets.fish.enable = true;
  };

  gtk = {
    enable = true;
  };
}
