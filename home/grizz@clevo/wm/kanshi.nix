{ ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [{
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "0,0";
          }];
        };
      } {
        profile = {
          name = "docked-study";
          outputs = [{
            criteria = "eDP-1";
            mode = "1920x1080@60Hz";
            position = "1366,0";
          } {
            criteria = "HDMI-A-1";
            mode = "1366x768@59.79000";
            position = "0,0";
          }];
        };
      }
    ];
  };
}
