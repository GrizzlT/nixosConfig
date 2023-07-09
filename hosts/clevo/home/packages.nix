{ pkgs, ... }:
{
    programs = {
      home-manager.enable = true;
    };

    home.packages = with pkgs; [
      neofetch

      pavucontrol
      libnotify

      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
}
