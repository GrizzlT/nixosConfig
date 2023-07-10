{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "agreety --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  environment.etc = {
    "regreet/hyprland.conf".text = ''
      exec-once=regreet; hyprctl dispatch exit
    '';
    "regreet/regreet.toml".text = ''
      [background]
      path = "${./home/hyprland/color-bg.jpg}"
      fit = "Fill"
      [commands]
      reboot = [ "systemctl", "reboot" ]
      poweroff = [ "systemctl", "poweroff" ]
    '';
  };
}
