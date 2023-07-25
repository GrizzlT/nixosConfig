{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        enable_posix_regex = true;
        width = 300;
        height = 120;
        notification_limit = 4;
        origin = "top-right";
        offset = "10x10";
        progress_bar_max_width = 200;
        progress_bar_corner_radius = 5;
        icon_corner_radius = 3;
        frame_width = 2;
        font = "Hack Nerd Font 10";
# dmenu = "anyrun?";
        corner_radius = 8;
        background = "#383c4a";
        foreground = "#ffffff";
        highlight = "#5af78e";
        frame_color = "#ffffff";
      };
    };
  };
}
