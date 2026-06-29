{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "eDP-1";
          path = ../../../wallpapers/sunset-1920x1080.jpg;
        }
        {
          monitor = "HDMI-A-1";
          path = ../../../wallpapers/sunset-1920x1080.jpg;
        }
      ];
    };
  };
}
