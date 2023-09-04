{ pkgs, hyprland, ... }:
let
  hyprlandPkg = hyprland.packages.${pkgs.system}.hyprland;
  callPackage = pkgs.callPackage;
  wlogout = callPackage ./wlogout.nix {};
in
{
  hyprland = {
    gamemode = callPackage ./gamemode.nix { hyprland = hyprlandPkg; };
    colorPicker = callPackage ./colorpicker.nix {};
    brightness = callPackage ./brightness.nix {};
    launcher = callPackage ./launcher.nix { hyprland = hyprlandPkg; };
    passage-fzf = callPackage ./passage-fzf.nix { hyprland = hyprlandPkg; };
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
