{ pkgs, ... }@inputs:
{
  _module.args = {
    hyprland = inputs.hyprland;
    stylix = inputs.stylix;
    myScripts = import ./scripts { inherit (inputs) pkgs hyprland; };
    myPackages = inputs.self.packages.${pkgs.system};
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
