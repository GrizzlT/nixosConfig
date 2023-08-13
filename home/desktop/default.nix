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

    ./librewolf.nix
    ./idle.nix
    ./wlogout
    ./zsh.nix
  ];

  home.keyboard = null;
  home.packages = with pkgs; [
    neofetch

    pavucontrol
    libnotify
    swaybg
    hyprpicker
    cliphist
    wl-clipboard
    swaylock

    discord
    spotifywm

    darktable
    inkscape
    gimp
  ];

  programs.foot.enable = true;
  programs.imv.enable = true;
}
