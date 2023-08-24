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
    ./dunst

    ./idle.nix
    ./wlogout
  ];

  home.keyboard = null;
  home.packages = with pkgs; [
    pavucontrol
    libnotify
    swaybg
    hyprpicker
    cliphist
    wl-clipboard
    swaylock

    ydotool

    grim
    slurp
  ];
}
