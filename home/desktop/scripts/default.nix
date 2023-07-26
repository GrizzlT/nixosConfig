{ pkgs, hyprland, ... }:
let
  callPackage = pkgs.callPackage;
  wlogout = callPackage ./wlogout.nix {};
in
{
  hyprland = {
    gamemode = callPackage ./gamemode.nix { hyprland = hyprland.packages.${pkgs.system}.hyprland; };
    colorPicker = callPackage ./colorpicker.nix {};
    brightness = callPackage ./brightness.nix {};
    volume = callPackage ./volume.nix {};
    inherit wlogout;
  };

  waybar = {
    check_battery = callPackage ./check_battery.nix {};
    inherit wlogout;
  };
}
