{ pkgs, hyprland, ... }:
let
  callPackage = pkgs.callPackage;
in
{
  hyprland = {
    gamemode = callPackage ./gamemode.nix { hyprland = hyprland.packages.${pkgs.system}.hyprland; };
    colorPicker = callPackage ./colorpicker.nix {};
    brightness = callPackage ./brightness.nix {};
    volume = callPackage ./volume.nix {};
  };

  waybar = {
    check_battery = callPackage ./check_battery.nix {};
  };
}
