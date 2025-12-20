{ pkgs, ... }:
{
  _module.args = {
    myScripts = import ./scripts {
      inherit pkgs;
    };
  };

  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    # ./kanshi.nix
    ./waybar
    ./dunst

    ./idle.nix
    ./wlogout
  ];

  home.keyboard = null;

  home.packages = with pkgs; [
    pavucontrol
    libnotify
  ];
}
