{ pkgs, myScripts, ... }:
let
  scripts = myScripts.waybar;
in
{
  programs.waybar = {
    enable = true;
    # style = ./style.css;
    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [ "cpu" "custom/mem" "temperature" "keyboard-state" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" ];

      cpu = {
        format = "{usage}%";
      };
      "custom/mem" = {
        format = "{} ";
        interval = 5;
        exec = "free -h | awk '/Mem:/{printf $3}'";
        tooltip = false;
      };
      temperature = {
        critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
      };
      keyboard-state = {
        numlock = true;
        capslock = true;
        format = {
          numlock = "N {icon}";
          capslock = "C {icon}";
        };
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };

      clock = {
        timezone = "Europe/Brussels";
        format = "{:%a %d %b, %I:%M %p}";
      };

      pulseaudio = {
        reverse-scrolling = 1;
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = "婢 {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["奄" "奔" "墳"];
        };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        min-length = 13;
      };
      network = {
        format = "{icon}";
        format-wifi = "{essid} {icon}";
        format-ethernet = "";
        format-disconnected = "...";
      };
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = ["" "" "" "" "" "" "" "" "" ""];
        on-update = "${scripts.check_battery}/bin/check_battery";
      };
    };
  };
}
