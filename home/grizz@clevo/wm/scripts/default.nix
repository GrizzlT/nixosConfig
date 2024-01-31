{ pkgs, ... }:
let
  callPackage = pkgs.callPackage;
  wlogout = callPackage ./wlogout.nix {};
in
{
  hyprland = {
    gamemode = callPackage ./gamemode.nix {};
    colorPicker = callPackage ./colorpicker.nix {};
    brightness = callPackage ./brightness.nix {};
    launcher = callPackage ./launcher.nix {};
    passage-fzf = callPackage ./passage-fzf.nix {};
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
