{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "${../../../wallpapers/sunset-1920x1080.jpg}" ];
      wallpaper = [
        "eDP-1,${../../../wallpapers/sunset-1920x1080.jpg}"
        "HDMI-A-1,${../../../wallpapers/sunset-1920x1080.jpg}"
      ];
    };
  };
}
