userName: { pkgs, ... }@inputs:
{
  home-manager.users.${userName} = {
    imports = [
      inputs.hyprland.homeManagerModules.default
      ./hyprland
      ./waybar
      ./wezterm

      ./packages.nix
      ./services.nix
    ];

    home = {
      stateVersion = "23.05";
      keyboard = null;
      pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };
}
