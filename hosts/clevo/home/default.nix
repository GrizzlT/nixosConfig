userName: { pkgs, ... }@inputs:
{
  home-manager.users.${userName} = {
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

    home.packages = with pkgs; [
      neofetch

      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];

    fonts.fontconfig.enable = true;

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
