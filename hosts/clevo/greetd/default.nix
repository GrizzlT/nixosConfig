{ pkgs, ... }:
{
  # Regreet service definition
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot'";
        user = "greeter";
      };
    };
  };
}
