{ pkgs, ... }:
{
  # Regreet packages requirements
  environment.systemPackages = with pkgs; [
    swaybg
    greetd.greetd
    greetd.regreet
  ];

  # Regreet service definition
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "Hyprland --config /etc/regreet/hyprland.conf";
        user = "greeter";
      };
      # initial_session = {
      #   command = "Hyprland";
      #   user = "grizz";
      # };
    };
  };

  # Regreet files
  environment.etc = {
    "regreet/bg.jpg".source = ../../../wallpapers/color-bg.jpg;
    "regreet/options.conf".source = ./options.conf;
    "regreet/hyprland.conf".text = ''
      source=/etc/regreet/options.conf
      exec-once=swaybg --mode fill --image /etc/regreet/bg.jpg
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
