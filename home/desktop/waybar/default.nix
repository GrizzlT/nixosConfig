{ pkgs, config, myScripts, ... }:
let
  scripts = myScripts.waybar;
in
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [ "keyboard-state" "idle_inhibitor" "hyprland/submap" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "cpu" "memory" "network" "battery" ];

      "hyprland/submap" = {
        on-click = "hyprctl dispatch submap reset";
        tooltip = "false";
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
          unlocked = "";
        };
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "󰒲";
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
        format-bluetooth-muted = "󰋎 {icon} {format_source}";
        format-muted = "󰖁 {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
            headphone = "";
            hands-free = "󰏴";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = ["󰕿" "󰖀" "󰕾"];
        };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        min-length = 13;
      };
      cpu = {
        interval = 5;
        format = "CPU {usage}%";
      };
      memory = {
        interval = 15;
        format = "Mem {percentage}%";
        tooltip-format = "Mem: {used:0.1f}GiB/{total:0.1f}GiB\nSwap: {swapUsed:0.1f}GiB/{swapTotal:0.1f}GiB";
      };
      network = {
        format = "{icon}";
        format-wifi = "{essid} {icon}";
        format-ethernet = "";
        format-disconnected = "...";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-disconnected = "Disconnected";
        format-icons = [ "󰤟" "󰤢" "󰤥" "󰖩"];
      };
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% 󰂄";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        on-update = "${scripts.check_battery}/bin/check_battery";
      };
    };
    style = (''
      @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
      @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

      @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
      @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};

      * {
        font-family: ${sansSerif.name};
        font-size: 15px;
        border-radius: 0;
        margin-top: 2px;
        min-height: 20px;
      }
    '') + (builtins.readFile ./style.css);
  };
}
