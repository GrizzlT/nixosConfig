{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      show-keyboard-layout = true;
    };
  };

  services.swayidle = {
    # enable = true;
    extraArgs = [ "-w" ];
    systemdTargets = [ "hyprland-session.target" ];
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
    ];
  };
}
