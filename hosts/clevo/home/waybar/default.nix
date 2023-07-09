{ pkgs, ... }:
let
  scriptsPath = ".config/waybar/scripts";
in
{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [ "cpu" "custom/mem" "temperature" "backlight" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" ];

      cpu = {
        format = "{usage}% at {avg_frequency} GHz";
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
        on-click = "pavucontrol";
        min-length = 13;
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
        on-update = "$HOME/.config/waybar/scripts/check_battery.sh";
      };
    };
  };

  home.file."${scriptsPath}/check_battery.sh" = {
    source = ./scripts/check_battery.sh;
    executable = true;
  };
}
