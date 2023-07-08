{ pkgs, ... }:
{
    programs = {
      home-manager.enable = true;

      wezterm = {
        enable = true;
      };
    };

    home.packages = with pkgs; [
      neofetch

      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];

    fonts.fontconfig.enable = true;
}
