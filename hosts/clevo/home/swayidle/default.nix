{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "383c4a";
      font = "Hack Nerd Font";
      font-size = "20";
      show-failed-attempts = true;
      show-keyboard-layout = true;
    };
  };

  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    systemdTarget = "hyprland-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 180;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 360;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
    ];
  };
}
