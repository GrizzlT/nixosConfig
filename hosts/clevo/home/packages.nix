{ pkgs, ... }:
{
    programs = {
      home-manager.enable = true;
      htop.enable = true;
      bottom.enable = true;

      librewolf.enable = true;
    };

    home.packages = with pkgs; [
      neofetch

      pavucontrol
      libnotify
      swaybg
      hyprpicker
      cliphist

      discord
      fractal
      spotifywm

      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
}
