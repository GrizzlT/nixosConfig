{ pkgs, ... }@inputs:
{
  _module.args = {
    hyprland = inputs.hyprland;
    stylix = inputs.stylix;
    myScripts = import ./scripts { inherit (inputs) pkgs hyprland; };
  };

  imports = [
    ./hyprland.nix
    ./waybar
    ./wezterm
    ./dunst

    ./style.nix
  ];

  home.keyboard = null;
  home.packages = with pkgs; [
    neofetch

    # pavucontrol
    # libnotify
    # swaybg
    # hyprpicker
    # cliphist
    # swaylock

    # spotifywm
  ];
}
