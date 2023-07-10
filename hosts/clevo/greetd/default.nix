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
}
