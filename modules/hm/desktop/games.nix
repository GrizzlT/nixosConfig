{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher
    unstable.lunar-client

    mangohud
    protonup-ng
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
