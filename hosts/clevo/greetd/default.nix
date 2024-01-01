{ pkgs, ... }:
let
  defaultSessionConfig = pkgs.writeTextFile {
    name = "defaultSessionConfig.conf";
    # exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    text = ''
      exec-once=${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit
      exec-once=${pkgs.swaybg}/bin/swaybg --mode fill --image ${../../../wallpapers/sunset-1920x1080.jpg}
      source=${./options.conf}
    '';
  };
in
{
  # Regreet service definition
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session Hyprland --config ${defaultSessionConfig}";
        user = "greeter";
      };
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../../wallpapers/sunset-1920x1080.jpg;
        fit = "Fill";
      };
      GTK = {
        cursor_theme_name = "phinger-cursors";
        icon_theme_name = "la-capitaine-icon-theme";
      };
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
  };
}
