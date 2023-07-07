userName: { pkgs, ... }@inputs:
{
  home-manager.users.${userName} = {
    home.stateVersion = "23.05";
    imports = [
      inputs.hyprland.homeManagerModules.default
      ./hyprland
    ];

    programs = {
      home-manager.enable = true;

      wezterm = {
        enable = true;
      };
    };
  };
}
