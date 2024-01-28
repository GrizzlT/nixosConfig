{ pkgs, ... }:
{
  _module.args = {
    myScripts = import ./scripts {
      inherit pkgs;
    };
  };

  imports = [
    ./hyprland.nix
    ./kanshi.nix
    ./waybar
    ./dunst

    ./idle.nix
    ./wlogout
  ];

  programs.foot.enable = true;

  home.keyboard = null;

  home.packages = with pkgs; [
    pavucontrol
    libnotify
  ];
}
