{ pkgs, ... }:
let
  callPackage = pkgs.callPackage;
  wlogout = callPackage ./wlogout.nix {};
in
{
  hyprland = {
    gamemode = callPackage ./gamemode.nix { hyprland = pkgs.inputPkgs.hyprland; };
    colorPicker = callPackage ./colorpicker.nix {};
    brightness = callPackage ./brightness.nix {};
    launcher = callPackage ./launcher.nix { hyprland = pkgs.inputPkgs.hyprland; };
    passage-fzf = callPackage ./passage-fzf.nix { hyprland = pkgs.inputPkgs.hyprland; };
    inherit wlogout;
  };

  waybar = {
    check_battery = callPackage ./check_battery.nix {};
    inherit wlogout;
  };

  zsh = {
    # untested v
    # fzf-pass = callPackage ./fzf-pass.nix {};
  };
}
