{ pkgs, ... }:
let
  grizzConfig = "/home/grizz/.config/hypr/grizz/options.conf";
in
{
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "Hyprland --config /etc/regreet/hyprland.conf";
        user = "greeter";
      };
    };
  };

  environment.etc = {
    "regreet/bg.jpg".source = ../../../wallpapers/color-bg.jpg;
    "regreet/hyprland.conf".text = ''
      source=${grizzConfig}
      exec-once=regreet; hyprctl dispatch exit
    '';
    "greetd/regreet.toml".text = ''
      [background]
      path = "/etc/regreet/bg.jpg"
      fit = "Fill"
      [commands]
      reboot = [ "systemctl", "reboot" ]
      poweroff = [ "systemctl", "poweroff" ]
    '';
  };
}
