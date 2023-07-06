userName: { pkgs, ... }@inputs:
{
  home-manager.users.${userName} = {
    home.stateVersion = "23.05";
    imports = [
        inputs.hyprland.homeManagerModules.default
    ];

    wayland.windowManager.hyprland.enable = true;
  };
}
