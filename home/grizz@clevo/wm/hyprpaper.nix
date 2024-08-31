{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "${../../../wallpapers/sunset-1920x1080.jpg}" "/home/grizz/.config/xyzjt.jpg" ];
      wallpaper = [
        "eDP-1,${../../../wallpapers/sunset-1920x1080.jpg}"
      ];
    };
  };
}
